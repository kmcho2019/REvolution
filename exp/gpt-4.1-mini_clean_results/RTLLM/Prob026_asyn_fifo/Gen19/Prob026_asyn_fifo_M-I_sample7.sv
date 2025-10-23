`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   rclk,
    input                   wrstn,   // active low write reset (async)
    input                   rrstn,   // active low read reset (async)
    input                   winc,    // write increment pulse (1 cycle)
    input                   rinc,    // read increment pulse (1 cycle)
    input  [WIDTH-1:0]      wdata,
    output                  wfull,
    output                  rempty,
    output reg [WIDTH-1:0]  rdata
);

    // Check DEPTH is a power of two (synthesis-time assertion)
    initial begin
        if ((DEPTH & (DEPTH - 1)) != 0) begin
            $error("DEPTH parameter must be a power of two.");
        end
    end

    // -------------------------------------------------------
    // Parameters for pointer widths
    localparam PTR_WIDTH = $clog2(DEPTH);
    localparam PTR_EXT = PTR_WIDTH + 1; // Extra bit for full detection

    // -------------------------------------------------------
    // Binary to Gray code converter (generate loop for better synthesis)
    function [PTR_EXT-1:0] bin2gray(input [PTR_EXT-1:0] bin);
        integer i;
        begin
            bin2gray[PTR_EXT-1] = bin[PTR_EXT-1];
            for (i = PTR_EXT-2; i >= 0; i = i -1)
                bin2gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

    // Gray to Binary converter (generate loop)
    function [PTR_EXT-1:0] gray2bin(input [PTR_EXT-1:0] gray);
        integer i;
        reg [PTR_EXT-1:0] bin;
        begin
            bin[PTR_EXT-1] = gray[PTR_EXT-1];
            for (i = PTR_EXT-2; i >= 0; i = i -1)
                bin[i] = bin[i+1] ^ gray[i];
            gray2bin = bin;
        end
    endfunction

    // -------------------------------------------------------
    // Write pointer domain logic

    reg [PTR_EXT-1:0] wptr_bin, wptr_bin_next;
    reg [PTR_EXT-1:0] wptr_gray;

    wire winc_en = winc & ~wfull;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin  <= 0;
            wptr_gray <= 0;
        end else begin
            wptr_bin  <= wptr_bin_next;
            wptr_gray <= bin2gray(wptr_bin_next);
        end
    end

    assign wptr_bin_next = wptr_bin + (winc_en ? 1'b1 : 1'b0);

    // -------------------------------------------------------
    // Read pointer domain logic

    reg [PTR_EXT-1:0] rptr_bin, rptr_bin_next;
    reg [PTR_EXT-1:0] rptr_gray;

    wire rinc_en = rinc & ~rempty;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin  <= 0;
            rptr_gray <= 0;
        end else begin
            rptr_bin  <= rptr_bin_next;
            rptr_gray <= bin2gray(rptr_bin_next);
        end
    end

    assign rptr_bin_next = rptr_bin + (rinc_en ? 1'b1 : 1'b0);

    // -------------------------------------------------------
    // Pointer synchronizers: two-stage synchronizers for crossing clock domains

    // Synchronize Gray-coded read pointer into write clock domain
    wire [PTR_EXT-1:0] rptr_gray_wclk_sync;
    gray_pointer_sync #(.WIDTH(PTR_EXT)) sync_r2w (
        .clk(wclk),
        .rstn(wrstn),
        .gray_in(rptr_gray),
        .gray_out(rptr_gray_wclk_sync)
    );

    // Synchronize Gray-coded write pointer into read clock domain
    wire [PTR_EXT-1:0] wptr_gray_rclk_sync;
    gray_pointer_sync #(.WIDTH(PTR_EXT)) sync_w2r (
        .clk(rclk),
        .rstn(rrstn),
        .gray_in(wptr_gray),
        .gray_out(wptr_gray_rclk_sync)
    );

    // -------------------------------------------------------
    // Full detection (write clock domain)
    // Condition: 
    // wptr_gray == {~rptr_gray[PTR_EXT-1], ~rptr_gray[PTR_EXT-2], rptr_gray[PTR_EXT-3:0]}
    wire [PTR_EXT-1:0] rptr_inv_msb = {~rptr_gray_wclk_sync[PTR_EXT-1], ~rptr_gray_wclk_sync[PTR_EXT-2]};
    wire [PTR_EXT-1:0] rptr_full_cmp = {rptr_inv_msb, rptr_gray_wclk_sync[PTR_EXT-3:0]};
    assign wfull = (wptr_gray == rptr_full_cmp);

    // -------------------------------------------------------
    // Empty detection (read clock domain)
    // Condition:
    // rptr_gray == synchronized wptr_gray
    assign rempty = (rptr_gray == wptr_gray_rclk_sync);

    // -------------------------------------------------------
    // RAM addressing using lower PTR_WIDTH bits of binary pointers

    wire [PTR_WIDTH-1:0] waddr = wptr_bin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rptr_bin[PTR_WIDTH-1:0];

    wire w_en = winc_en;
    wire r_en = rinc_en;

    wire [WIDTH-1:0] ram_rdata;

    // Register output data only on valid read to reduce toggling
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (r_en)
            rdata <= ram_rdata;
        // else hold previous value naturally, no else needed to reduce toggling
    end

    // -------------------------------------------------------
    // Instantiate Dual-port RAM for data storage
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_dual_port_RAM (
        .wclk(wclk),
        .wenc(w_en),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(r_en),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

endmodule


// -------------------------------------------------------
// Two-stage Gray code synchronizer module for pointer crossing
module gray_pointer_sync #(
    parameter WIDTH = 5
)(
    input  wire             clk,
    input  wire             rstn,
    input  wire [WIDTH-1:0] gray_in,
    output reg  [WIDTH-1:0] gray_out
);

    reg [WIDTH-1:0] sync_ff1;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            sync_ff1 <= 0;
            gray_out <= 0;
        end else begin
            sync_ff1 <= gray_in;
            gray_out <= sync_ff1;
        end
    end

endmodule

// -------------------------------------------------------
// Dual-port RAM: independent read and write clocks, synchronous writes and reads
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                       wclk,
    input                       wenc,
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0]          wdata,
    input                       rclk,
    input                       renc,
    input  [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]      rdata
);

    // RAM storage
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write port
    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    // Read port
    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end

endmodule
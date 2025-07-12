`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                  wclk,
    input                  rclk,
    input                  wrstn,
    input                  rrstn,
    input                  winc,
    input                  rinc,
    input      [WIDTH-1:0] wdata,
    output                 wfull,
    output                 rempty,
    output     [WIDTH-1:0] rdata
);

    localparam PTR_WIDTH = $clog2(DEPTH);
    localparam PTR_EXT   = PTR_WIDTH + 1;

    // Write Controller signals
    wire [PTR_EXT-1:0] wptr_bin;
    wire [PTR_EXT-1:0] wptr_gray;
    wire [PTR_EXT-1:0] rptr_gray_sync_wclk;

    // Read Controller signals
    wire [PTR_EXT-1:0] rptr_bin;
    wire [PTR_EXT-1:0] rptr_gray;
    wire [PTR_EXT-1:0] wptr_gray_sync_rclk;

    // Write enable gated with full
    wire w_en = winc & ~wfull;
    // Read enable gated with empty
    wire r_en = rinc & ~rempty;

    // Dual-port RAM addresses
    wire [PTR_WIDTH-1:0] waddr = wptr_bin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rptr_bin[PTR_WIDTH-1:0];

    wire [WIDTH-1:0] ram_rdata;

    // Write controller: generates write pointers
    write_controller #(
        .PTR_EXT(PTR_EXT)
    ) w_ctrl (
        .clk(wclk),
        .rst_n(wrstn),
        .winc(w_en),
        .rptr_gray_sync(rptr_gray_sync_wclk),
        .wptr_bin(wptr_bin),
        .wptr_gray(wptr_gray),
        .wfull(wfull)
    );

    // Read controller: generates read pointers
    read_controller #(
        .PTR_EXT(PTR_EXT)
    ) r_ctrl (
        .clk(rclk),
        .rst_n(rrstn),
        .rinc(r_en),
        .wptr_gray_sync(wptr_gray_sync_rclk),
        .rptr_bin(rptr_bin),
        .rptr_gray(rptr_gray),
        .rempty(rempty)
    );

    // Synchronize read pointer to write clock domain (two-stage)
    pointer_synchronizer #(
        .WIDTH(PTR_EXT)
    ) rptr_sync_wclk (
        .clk(wclk),
        .rst_n(wrstn),
        .in(rptr_gray),
        .out(rptr_gray_sync_wclk)
    );

    // Synchronize write pointer to read clock domain (two-stage)
    pointer_synchronizer #(
        .WIDTH(PTR_EXT)
    ) wptr_sync_rclk (
        .clk(rclk),
        .rst_n(rrstn),
        .in(wptr_gray),
        .out(wptr_gray_sync_rclk)
    );

    // Register rdata synchronized with rclk
    reg [WIDTH-1:0] rdata_reg = {WIDTH{1'b0}};
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn)
            rdata_reg <= 0;
        else if (r_en)
            rdata_reg <= ram_rdata;
    end
    assign rdata = rdata_reg;

    // Instantiate dual-port RAM
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
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


// Write controller: manages write pointer and full detection
module write_controller #(
    parameter PTR_EXT = 5 // default for DEPTH=16 (4 bits + 1)
)(
    input                   clk,
    input                   rst_n,
    input                   winc,
    input  [PTR_EXT-1:0]    rptr_gray_sync,
    output reg [PTR_EXT-1:0] wptr_bin,
    output     [PTR_EXT-1:0] wptr_gray,
    output                  wfull
);

    wire [PTR_EXT-1:0] wptr_bin_next = wptr_bin + (winc ? 1'b1 : 1'b0);

    // Binary to Gray conversion (continuous assign)
    assign wptr_gray = bin2gray(wptr_bin);

    // Full detection uses next pointer
    wire [PTR_EXT-1:0] wptr_gray_next = bin2gray(wptr_bin_next);

    // Full condition: MSB and next MSB inverted, lower bits equal
    assign wfull = (wptr_gray_next[PTR_EXT-3:0] == rptr_gray_sync[PTR_EXT-3:0]) &&
                   (wptr_gray_next[PTR_EXT-1]   != rptr_gray_sync[PTR_EXT-1]) &&
                   (wptr_gray_next[PTR_EXT-2]   != rptr_gray_sync[PTR_EXT-2]);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            wptr_bin <= 0;
        else if (winc && !wfull)
            wptr_bin <= wptr_bin + 1'b1;
    end

    // Binary to Gray function
    function [PTR_EXT-1:0] bin2gray(input [PTR_EXT-1:0] bin);
        integer i;
        begin
            bin2gray[PTR_EXT-1] = bin[PTR_EXT-1];
            for (i = PTR_EXT-2; i >= 0; i = i - 1)
                bin2gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

endmodule


// Read controller: manages read pointer and empty detection
module read_controller #(
    parameter PTR_EXT = 5
)(
    input                   clk,
    input                   rst_n,
    input                   rinc,
    input  [PTR_EXT-1:0]    wptr_gray_sync,
    output reg [PTR_EXT-1:0] rptr_bin,
    output     [PTR_EXT-1:0] rptr_gray,
    output                  rempty
);

    // Binary to Gray function
    function [PTR_EXT-1:0] bin2gray(input [PTR_EXT-1:0] bin);
        integer i;
        begin
            bin2gray[PTR_EXT-1] = bin[PTR_EXT-1];
            for (i = PTR_EXT-2; i >= 0; i = i - 1)
                bin2gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

    assign rptr_gray = bin2gray(rptr_bin);

    // Empty detection: compare read pointer with synchronized write pointer
    assign rempty = (rptr_gray == wptr_gray_sync);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            rptr_bin <= 0;
        else if (rinc && !rempty)
            rptr_bin <= rptr_bin + 1'b1;
    end

endmodule


// Pointer synchronizer: 2-stage synchronizer for crossing clock domains
module pointer_synchronizer #(
    parameter WIDTH = 5
)(
    input                   clk,
    input                   rst_n,
    input   [WIDTH-1:0]     in,
    output reg [WIDTH-1:0]  out
);

    reg [WIDTH-1:0] sync_ff;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync_ff <= 0;
            out <= 0;
        end else begin
            sync_ff <= in;
            out <= sync_ff;
        end
    end

endmodule


// Dual-port RAM module for asynchronous FIFO storage
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                         wclk,
    input                         wenc,
    input       [$clog2(DEPTH)-1:0] waddr,
    input       [WIDTH-1:0]       wdata,
    input                         rclk,
    input                         renc,
    input       [$clog2(DEPTH)-1:0] raddr,
    output reg  [WIDTH-1:0]       rdata
);

    reg [WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge wclk) begin
        if (wenc)
            mem[waddr] <= wdata;
    end

    always @(posedge rclk) begin
        if (renc)
            rdata <= mem[raddr];
    end

endmodule
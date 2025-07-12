`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   rclk,
    input                   wrstn,   // Active low reset for write domain
    input                   rrstn,   // Active low reset for read domain
    input                   winc,    // Write increment (write enable)
    input                   rinc,    // Read increment (read enable)
    input      [WIDTH-1:0]  wdata,
    output                  wfull,
    output                  rempty,
    output reg [WIDTH-1:0]  rdata
);

    localparam PTR_WIDTH = $clog2(DEPTH);
    localparam PTR_EXT = PTR_WIDTH + 1; // One extra bit for full detection

    // --- Gray code conversion functions for small pointer widths ---
    // Convert binary to Gray code directly for PTR_EXT bits
    function [PTR_EXT-1:0] bin2gray(input [PTR_EXT-1:0] bin);
    begin
        bin2gray = (bin >> 1) ^ bin;
    end
    endfunction

    // Convert Gray code to binary directly for PTR_EXT bits
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

    // --- Write domain registers and wires ---
    reg  [PTR_EXT-1:0] wptr_bin, wptr_gray;
    wire [PTR_EXT-1:0] wptr_bin_next = wptr_bin + 1;

    // Write enable gated by not full condition
    wire w_en = winc & ~wfull;

    // --- Read domain registers and wires ---
    reg  [PTR_EXT-1:0] rptr_bin, rptr_gray;
    wire [PTR_EXT-1:0] rptr_bin_next = rptr_bin + 1;

    // Read enable gated by not empty condition
    wire r_en = rinc & ~rempty;

    // --- Pointer synchronization registers ---
    reg [PTR_EXT-1:0] rptr_gray_wclk1, rptr_gray_wclk2;
    reg [PTR_EXT-1:0] wptr_gray_rclk1, wptr_gray_rclk2;

    // Write pointer update (write clock domain)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin  <= 0;
            wptr_gray <= 0;
        end else if (w_en) begin
            wptr_bin  <= wptr_bin_next;
            wptr_gray <= bin2gray(wptr_bin_next);
        end
    end

    // Read pointer update (read clock domain)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin  <= 0;
            rptr_gray <= 0;
        end else if (r_en) begin
            rptr_bin  <= rptr_bin_next;
            rptr_gray <= bin2gray(rptr_bin_next);
        end
    end

    // Synchronize read pointer into write clock domain (2-stage synchronizer)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_wclk1 <= 0;
            rptr_gray_wclk2 <= 0;
        end else begin
            rptr_gray_wclk1 <= rptr_gray;
            rptr_gray_wclk2 <= rptr_gray_wclk1;
        end
    end

    // Synchronize write pointer into read clock domain (2-stage synchronizer)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_rclk1 <= 0;
            wptr_gray_rclk2 <= 0;
        end else begin
            wptr_gray_rclk1 <= wptr_gray;
            wptr_gray_rclk2 <= wptr_gray_rclk1;
        end
    end

    // Convert synchronized pointers back to binary for address calculation
    wire [PTR_EXT-1:0] rptr_bin_sync = gray2bin(rptr_gray_wclk2);
    wire [PTR_EXT-1:0] wptr_bin_sync = gray2bin(wptr_gray_rclk2);

    // Extract address from binary pointers (lower PTR_WIDTH bits)
    wire [PTR_WIDTH-1:0] waddr = wptr_bin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rptr_bin[PTR_WIDTH-1:0];

    // FIFO full detection:
    // FIFO is full when write pointer's Gray code equals read pointer's Gray code with inverted top two bits
    assign wfull = (wptr_gray == {~rptr_gray_wclk2[PTR_EXT-1:PTR_EXT-2], rptr_gray_wclk2[PTR_EXT-3:0]});

    // FIFO empty detection:
    // FIFO is empty when read pointer's Gray code equals synchronized write pointer's Gray code
    assign rempty = (rptr_gray == wptr_gray_rclk2);

    // RAM read data wire
    wire [WIDTH-1:0] ram_rdata;

    // Register read data on read clock domain when reading and FIFO not empty
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (r_en)
            rdata <= ram_rdata;
    end

    // Instantiate the dual-port RAM submodule
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram_inst (
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


// Dual-port RAM module with independent clocks for read and write ports
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                         wclk,
    input                         wenc,
    input      [$clog2(DEPTH)-1:0] waddr,
    input      [WIDTH-1:0]        wdata,
    input                         rclk,
    input                         renc,
    input      [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]        rdata
);
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
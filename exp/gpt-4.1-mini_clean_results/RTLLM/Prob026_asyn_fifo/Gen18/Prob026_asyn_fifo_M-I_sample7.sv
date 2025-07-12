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

    // Number of address bits
    localparam PTR_WIDTH = $clog2(DEPTH);
    // Pointer width + 1 for wrap-around detection
    localparam PTR_EXT = PTR_WIDTH + 1;

    // -------------------------------------------------------
    // Binary to Gray code converter (for PTR_EXT bits)
    function [PTR_EXT-1:0] bin2gray(input [PTR_EXT-1:0] bin);
        bin2gray = bin ^ (bin >> 1);
    endfunction

    // Gray code to Binary converter (for PTR_EXT bits)
    function [PTR_EXT-1:0] gray2bin(input [PTR_EXT-1:0] gray);
        integer i;
        reg [PTR_EXT-1:0] bin;
    begin
        bin[PTR_EXT-1] = gray[PTR_EXT-1];
        for (i = PTR_EXT-2; i >= 0; i = i - 1)
            bin[i] = bin[i+1] ^ gray[i];
        gray2bin = bin;
    end
    endfunction

    // -------------------------------------------------------
    // Write pointer domain registers and logic

    // Binary write pointer, incremented by 1 when winc and not full
    reg [PTR_EXT-1:0] wptr_bin, wptr_bin_next;
    // Gray-coded write pointer
    reg [PTR_EXT-1:0] wptr_gray;

    wire winc_en = winc & ~wfull;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else begin
            wptr_bin <= wptr_bin_next;
            wptr_gray <= bin2gray(wptr_bin_next);
        end
    end

    assign wptr_bin_next = wptr_bin + (winc_en ? 1'b1 : 1'b0);

    // -------------------------------------------------------
    // Read pointer domain registers and logic

    // Binary read pointer, incremented by 1 when rinc and not empty
    reg [PTR_EXT-1:0] rptr_bin, rptr_bin_next;
    // Gray-coded read pointer
    reg [PTR_EXT-1:0] rptr_gray;

    wire rinc_en = rinc & ~rempty;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else begin
            rptr_bin <= rptr_bin_next;
            rptr_gray <= bin2gray(rptr_bin_next);
        end
    end

    assign rptr_bin_next = rptr_bin + (rinc_en ? 1'b1 : 1'b0);

    // -------------------------------------------------------
    // Synchronizers for crossing clock domains

    // Synchronize Gray-coded read pointer into write clock domain (2-stage synchronizer)
    reg [PTR_EXT-1:0] rptr_gray_wclk_meta, rptr_gray_wclk_sync;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_wclk_meta <= 0;
            rptr_gray_wclk_sync <= 0;
        end else begin
            rptr_gray_wclk_meta <= rptr_gray;
            rptr_gray_wclk_sync <= rptr_gray_wclk_meta;
        end
    end

    // Synchronize Gray-coded write pointer into read clock domain (2-stage synchronizer)
    reg [PTR_EXT-1:0] wptr_gray_rclk_meta, wptr_gray_rclk_sync;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_rclk_meta <= 0;
            wptr_gray_rclk_sync <= 0;
        end else begin
            wptr_gray_rclk_meta <= wptr_gray;
            wptr_gray_rclk_sync <= wptr_gray_rclk_meta;
        end
    end

    // -------------------------------------------------------
    // Full condition (in write clock domain)
    // FIFO is full when the write pointer is exactly one cycle ahead of the read pointer,
    // with MSBs inverted, i.e.:
    // wptr_gray == {~rptr_gray[PTR_EXT-1:PTR_EXT-2], rptr_gray[PTR_EXT-3:0]}
    wire [PTR_EXT-1:0] rptr_gray_inv_top = {~rptr_gray_wclk_sync[PTR_EXT-1], ~rptr_gray_wclk_sync[PTR_EXT-2]};
    wire [PTR_EXT-1:0] rptr_gray_full_cmp = {rptr_gray_inv_top, rptr_gray_wclk_sync[PTR_EXT-3:0]};
    assign wfull = (wptr_gray == rptr_gray_full_cmp);

    // -------------------------------------------------------
    // Empty condition (in read clock domain)
    // FIFO is empty when the synchronized write pointer equals the read pointer
    assign rempty = (rptr_gray == wptr_gray_rclk_sync);

    // -------------------------------------------------------
    // RAM address signals: use lower PTR_WIDTH bits of binary pointers for RAM addressing
    wire [PTR_WIDTH-1:0] waddr = wptr_bin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rptr_bin[PTR_WIDTH-1:0];

    // Write enable to RAM only when write enable asserted and FIFO not full
    wire w_en = winc_en;
    // Read enable to RAM only when read enable asserted and FIFO not empty
    wire r_en = rinc_en;

    // RAM read data bus
    wire [WIDTH-1:0] ram_rdata;

    // Register output data on read clock when reading
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (r_en)
            rdata <= ram_rdata;
        else
            rdata <= rdata; // hold previous read data when no read
    end

    // -------------------------------------------------------
    // Instantiate the dual-port RAM module for storage

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
// Dual-port RAM: separate read and write clocks with independent enables
// Simple synchronous RAM with write on wclk and read on rclk
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
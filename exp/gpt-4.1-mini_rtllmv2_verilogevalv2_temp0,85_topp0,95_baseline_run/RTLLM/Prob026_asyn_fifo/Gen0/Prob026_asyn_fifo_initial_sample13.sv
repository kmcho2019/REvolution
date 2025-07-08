`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   rclk,
    input                   wrstn,
    input                   rrstn,
    input                   winc,
    input                   rinc,
    input   [WIDTH-1:0]     wdata,
    output                  wfull,
    output                  rempty,
    output  [WIDTH-1:0]     rdata
);

    // Address width calculation
    localparam ADDR_WIDTH = $clog2(DEPTH);

    // Gray code width is ADDR_WIDTH + 1 for full/empty detection logic
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    //==========================================================================
    // Dual-port RAM submodule (depth = DEPTH, width = WIDTH)
    //==========================================================================
    dual_port_RAM #(
        .DEPTH(DEPTH),
        .WIDTH(WIDTH)
    ) ram (
        .wclk   (wclk),
        .wenc   (winc & ~wfull),                     // write enable gated by ~full
        .waddr  (waddr_bin),
        .wdata  (wdata),
        .rclk   (rclk),
        .renc   (rinc & ~rempty),                     // read enable gated by ~empty
        .raddr  (raddr_bin),
        .rdata  (rdata)
    );

    //==========================================================================
    // Write pointer logic (binary and gray)
    //==========================================================================
    reg [ADDR_WIDTH:0] wptr_bin;    // binary pointer, extended by 1 bit
    reg [ADDR_WIDTH:0] wptr;        // gray pointer

    // Write pointer increment logic
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr_bin <= 0;
        else if (winc & ~wfull)
            wptr_bin <= wptr_bin + 1'b1;
    end

    // Binary to Gray conversion function
    function [PTR_WIDTH-1:0] bin2gray;
        input [PTR_WIDTH-1:0] bin;
        begin
            bin2gray = (bin >> 1) ^ bin;
        end
    endfunction

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr <= 0;
        else
            wptr <= bin2gray(wptr_bin);
    end

    // Write address is lower ADDR_WIDTH bits of binary pointer
    wire [ADDR_WIDTH-1:0] waddr_bin = wptr_bin[ADDR_WIDTH-1:0];

    //==========================================================================
    // Read pointer logic (binary and gray)
    //==========================================================================
    reg [ADDR_WIDTH:0] rptr_bin;    // binary pointer, extended by 1 bit
    reg [ADDR_WIDTH:0] rptr;        // gray pointer

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr_bin <= 0;
        else if (rinc & ~rempty)
            rptr_bin <= rptr_bin + 1'b1;
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr <= 0;
        else
            rptr <= bin2gray(rptr_bin);
    end

    // Read address is lower ADDR_WIDTH bits of binary pointer
    wire [ADDR_WIDTH-1:0] raddr_bin = rptr_bin[ADDR_WIDTH-1:0];

    //==========================================================================
    // Synchronize read pointer into write clock domain (for full detection)
    // Two-stage synchronizer
    //==========================================================================
    reg [PTR_WIDTH-1:0] rptr_wclk_meta;
    reg [PTR_WIDTH-1:0] rptr_wclk_sync;

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_wclk_meta <= 0;
            rptr_wclk_sync <= 0;
        end else begin
            rptr_wclk_meta <= rptr;
            rptr_wclk_sync <= rptr_wclk_meta;
        end
    end

    //==========================================================================
    // Synchronize write pointer into read clock domain (for empty detection)
    // Two-stage synchronizer
    //==========================================================================
    reg [PTR_WIDTH-1:0] wptr_rclk_meta;
    reg [PTR_WIDTH-1:0] wptr_rclk_sync;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_rclk_meta <= 0;
            wptr_rclk_sync <= 0;
        end else begin
            wptr_rclk_meta <= wptr;
            wptr_rclk_sync <= wptr_rclk_meta;
        end
    end

    //==========================================================================
    // Full flag generation
    // FIFO full when:
    // - write pointer is one cycle ahead of read pointer
    //   i.e. wptr == {~rptr_wclk_sync[PTR_WIDTH-1:PTR_WIDTH-2], rptr_wclk_sync[PTR_WIDTH-3:0]}
    //==========================================================================
    wire [PTR_WIDTH-1:0] rptr_wclk_sync_inv_msb;
    assign rptr_wclk_sync_inv_msb = {~rptr_wclk_sync[PTR_WIDTH-1], ~rptr_wclk_sync[PTR_WIDTH-2], rptr_wclk_sync[PTR_WIDTH-3:0]};
    assign wfull = (wptr == rptr_wclk_sync_inv_msb);

    //==========================================================================
    // Empty flag generation
    // FIFO empty when:
    // - read pointer equals synchronized write pointer in read clock domain
    //==========================================================================
    assign rempty = (rptr == wptr_rclk_sync);

endmodule


//==============================================================================
// Dual-port RAM module with separate read and write clocks and enables
// DEPTH and WIDTH are parameters
// Addresses are binary indexed
//==============================================================================
module dual_port_RAM #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
)(
    input                   wclk,
    input                   wenc,
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0]      wdata,
    input                   rclk,
    input                   renc,
    input  [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]  rdata
);

    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

    // Write port - synchronous write with write enable
    always @(posedge wclk) begin
        if (wenc)
            RAM_MEM[waddr] <= wdata;
    end

    // Read port - synchronous read with read enable
    always @(posedge rclk) begin
        if (renc)
            rdata <= RAM_MEM[raddr];
        else
            rdata <= rdata; // hold data if no read enable
    end

endmodule
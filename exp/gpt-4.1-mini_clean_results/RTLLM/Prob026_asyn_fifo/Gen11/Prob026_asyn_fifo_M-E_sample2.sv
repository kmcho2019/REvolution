`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                  wclk,
    input                  rclk,
    input                  wrstn,   // Active low synchronous reset for write domain
    input                  rrstn,   // Active low synchronous reset for read domain
    input                  winc,    // Write enable
    input                  rinc,    // Read enable
    input  [WIDTH-1:0]     wdata,   // Data input
    output                 wfull,   // FIFO full indicator (write side)
    output                 rempty,  // FIFO empty indicator (read side)
    output reg [WIDTH-1:0] rdata    // Data output
);

    localparam PTR_WIDTH = $clog2(DEPTH);
    localparam EXT_PTR_WIDTH = PTR_WIDTH + 2; 
    // Add 2 bits MSBs to implement full/empty detection per spec with 4-bit Gray pointers (DEPTH=16)
    // EXT_PTR_WIDTH is 2 bits wider than PTR_WIDTH to include MSBs for full detection per requirement

    // Write domain registers
    reg [EXT_PTR_WIDTH-1:0] wptr_bin;    // Binary write pointer
    reg [EXT_PTR_WIDTH-1:0] wptr_gray;   // Gray coded write pointer

    // Read domain registers
    reg [EXT_PTR_WIDTH-1:0] rptr_bin;    // Binary read pointer
    reg [EXT_PTR_WIDTH-1:0] rptr_gray;   // Gray coded read pointer

    // Synchronized pointers crossing clock domains (Gray code)
    reg [EXT_PTR_WIDTH-1:0] rptr_gray_sync_wclk;  // Read pointer synchronized into write clock domain
    reg [EXT_PTR_WIDTH-1:0] wptr_gray_sync_rclk;  // Write pointer synchronized into read clock domain

    // Internal wires for addresses to RAM (lower PTR_WIDTH bits of binary pointers)
    wire [PTR_WIDTH-1:0] waddr = wptr_bin[PTR_WIDTH-1:0];
    wire [PTR_WIDTH-1:0] raddr = rptr_bin[PTR_WIDTH-1:0];

    // Write and read enables gated with full and empty flags
    wire w_en = winc & ~wfull;
    wire r_en = rinc & ~rempty;

    // RAM read data wire
    wire [WIDTH-1:0] ram_rdata;

    //
    // Write pointer update and Gray code generation (synchronous reset active low)
    //
    always @(posedge wclk) begin
        if (!wrstn) begin
            wptr_bin  <= 0;
            wptr_gray <= 0;
        end else if (w_en) begin
            wptr_bin  <= wptr_bin + 1'b1;
            wptr_gray <= bin2gray(wptr_bin + 1'b1);
        end
    end

    //
    // Read pointer update and Gray code generation (synchronous reset active low)
    //
    always @(posedge rclk) begin
        if (!rrstn) begin
            rptr_bin  <= 0;
            rptr_gray <= 0;
        end else if (r_en) begin
            rptr_bin  <= rptr_bin + 1'b1;
            rptr_gray <= bin2gray(rptr_bin + 1'b1);
        end
    end

    //
    // Two-stage synchronizers for crossing clock domains (Gray pointers only)
    //

    // Synchronize read pointer gray into write clock domain
    always @(posedge wclk) begin
        if (!wrstn) begin
            rptr_gray_sync_wclk <= 0;
        end else begin
            rptr_gray_sync_wclk <= {rptr_gray_sync_wclk[EXT_PTR_WIDTH-2:0], rptr_gray[0]};
            // Shift register for each bit to implement two-stage sync
            // We replicate this bitwise shift for the entire bus:
            // But simpler and clearer is to use two registers per bit (below)
        end
    end

    // Implemented as vector two-stage synchronizer for clarity:
    reg [EXT_PTR_WIDTH-1:0] rptr_gray_sync_wclk_1;
    always @(posedge wclk) begin
        if (!wrstn) begin
            rptr_gray_sync_wclk_1 <= 0;
            rptr_gray_sync_wclk   <= 0;
        end else begin
            rptr_gray_sync_wclk_1 <= rptr_gray;
            rptr_gray_sync_wclk   <= rptr_gray_sync_wclk_1;
        end
    end

    // Synchronize write pointer gray into read clock domain
    reg [EXT_PTR_WIDTH-1:0] wptr_gray_sync_rclk_1;
    always @(posedge rclk) begin
        if (!rrstn) begin
            wptr_gray_sync_rclk_1 <= 0;
            wptr_gray_sync_rclk   <= 0;
        end else begin
            wptr_gray_sync_rclk_1 <= wptr_gray;
            wptr_gray_sync_rclk   <= wptr_gray_sync_rclk_1;
        end
    end

    //
    // Convert synchronized Gray pointers to binary for comparison logic
    //
    wire [EXT_PTR_WIDTH-1:0] rptr_bin_sync_wclk = gray2bin(rptr_gray_sync_wclk);
    wire [EXT_PTR_WIDTH-1:0] wptr_bin_sync_rclk = gray2bin(wptr_gray_sync_rclk);

    //
    // FIFO full logic - at write domain:
    // Full when upper 2 bits of next write pointer are inverse of synchronized read pointer's upper 2 bits
    // and lower bits equal.
    //
    wire [EXT_PTR_WIDTH-1:0] wptr_bin_next = wptr_bin + 1'b1;

    // Check full condition:
    wire full_cond_upper_bits = (wptr_bin_next[EXT_PTR_WIDTH-1]     == ~rptr_bin_sync_wclk[EXT_PTR_WIDTH-1]) &&
                               (wptr_bin_next[EXT_PTR_WIDTH-2]     == ~rptr_bin_sync_wclk[EXT_PTR_WIDTH-2]);

    wire full_cond_lower_bits = (wptr_bin_next[EXT_PTR_WIDTH-3:0] == rptr_bin_sync_wclk[EXT_PTR_WIDTH-3:0]);

    assign wfull = full_cond_upper_bits && full_cond_lower_bits;

    //
    // FIFO empty logic - at read domain:
    // Empty when synchronized write pointer equals read pointer.
    //
    assign rempty = (rptr_bin == wptr_bin_sync_rclk);

    //
    // Register read data output on read clock gated by read enable
    //
    always @(posedge rclk) begin
        if (!rrstn)
            rdata <= {WIDTH{1'b0}};
        else if (r_en)
            rdata <= ram_rdata;
    end

    //
    // Instantiate dual-port RAM module
    //
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


    //
    // Function: Binary to Gray code conversion
    //
    function [EXT_PTR_WIDTH-1:0] bin2gray;
        input [EXT_PTR_WIDTH-1:0] bin;
        integer i;
        begin
            bin2gray[EXT_PTR_WIDTH-1] = bin[EXT_PTR_WIDTH-1];
            for (i = EXT_PTR_WIDTH-2; i >= 0; i = i -1)
                bin2gray[i] = bin[i+1] ^ bin[i];
        end
    endfunction

    //
    // Function: Gray to Binary code conversion
    //
    function [EXT_PTR_WIDTH-1:0] gray2bin;
        input [EXT_PTR_WIDTH-1:0] gray;
        integer j;
        begin
            gray2bin[EXT_PTR_WIDTH-1] = gray[EXT_PTR_WIDTH-1];
            for (j = EXT_PTR_WIDTH-2; j >= 0; j = j -1)
                gray2bin[j] = gray2bin[j+1] ^ gray[j];
        end
    endfunction

endmodule



//
// Dual-port RAM with independent clocks, write enable, and read enable
//
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input                      wclk,
    input                      wenc,
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0]         wdata,
    input                      rclk,
    input                      renc,
    input  [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0]     rdata
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
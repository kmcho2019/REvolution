`timescale 1ns/1ps

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
    input  [WIDTH-1:0]      wdata,
    output reg              wfull,
    output reg              rempty,
    output [WIDTH-1:0]      rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH  = ADDR_WIDTH + 1;

    // Binary write and read pointers
    reg [PTR_WIDTH-1:0] wptr_bin;
    reg [PTR_WIDTH-1:0] rptr_bin;

    // Gray code pointers
    reg [PTR_WIDTH-1:0] wptr_gray;
    reg [PTR_WIDTH-1:0] rptr_gray;

    // Synchronizers for pointers crossing clock domains
    reg [PTR_WIDTH-1:0] rptr_gray_wclk_sync1, rptr_gray_wclk_sync2;
    reg [PTR_WIDTH-1:0] wptr_gray_rclk_sync1, wptr_gray_rclk_sync2;

    // Functions for Gray code conversions
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        bin2gray = (bin >> 1) ^ bin;
    endfunction

    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        reg [PTR_WIDTH-1:0] bin;
        begin
            bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i - 1)
                bin[i] = bin[i+1] ^ gray[i];
            gray2bin = bin;
        end
    endfunction

    // Write pointer and Gray code update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin  <= 0;
            wptr_gray <= 0;
        end else if (winc && !wfull) begin
            wptr_bin  <= wptr_bin + 1'b1;
            wptr_gray <= bin2gray(wptr_bin + 1'b1);
        end else begin
            wptr_bin  <= wptr_bin;
            wptr_gray <= wptr_gray;
        end
    end

    // Read pointer and Gray code update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin  <= 0;
            rptr_gray <= 0;
        end else if (rinc && !rempty) begin
            rptr_bin  <= rptr_bin + 1'b1;
            rptr_gray <= bin2gray(rptr_bin + 1'b1);
        end else begin
            rptr_bin  <= rptr_bin;
            rptr_gray <= rptr_gray;
        end
    end

    // Synchronize read pointer Gray code into write clock domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_wclk_sync1 <= 0;
            rptr_gray_wclk_sync2 <= 0;
        end else begin
            rptr_gray_wclk_sync1 <= rptr_gray;
            rptr_gray_wclk_sync2 <= rptr_gray_wclk_sync1;
        end
    end

    // Synchronize write pointer Gray code into read clock domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_rclk_sync1 <= 0;
            wptr_gray_rclk_sync2 <= 0;
        end else begin
            wptr_gray_rclk_sync1 <= wptr_gray;
            wptr_gray_rclk_sync2 <= wptr_gray_rclk_sync1;
        end
    end

    // Convert synchronized Gray pointers back to binary for comparison
    wire [PTR_WIDTH-1:0] rptr_bin_wclk = gray2bin(rptr_gray_wclk_sync2);
    wire [PTR_WIDTH-1:0] wptr_bin_rclk = gray2bin(wptr_gray_rclk_sync2);

    // Full condition function
    function is_full(input [PTR_WIDTH-1:0] wptr, input [PTR_WIDTH-1:0] rptr_sync);
        reg [PTR_WIDTH-1:0] rptr_inv;
        begin
            // Invert MSBs of rptr_sync according to full condition
            rptr_inv = {~rptr_sync[PTR_WIDTH-1], ~rptr_sync[PTR_WIDTH-2], rptr_sync[PTR_WIDTH-3:0]};
            is_full = (wptr == rptr_inv);
        end
    endfunction

    // Empty condition function
    function is_empty(input [PTR_WIDTH-1:0] rptr, input [PTR_WIDTH-1:0] wptr_sync);
        begin
            is_empty = (rptr == wptr_sync);
        end
    endfunction

    // Update full flag on write clock
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wfull <= 1'b0;
        end else begin
            wfull <= is_full(wptr_gray, rptr_gray_wclk_sync2);
        end
    end

    // Update empty flag on read clock
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rempty <= 1'b1;
        end else begin
            rempty <= is_empty(rptr_gray, wptr_gray_rclk_sync2);
        end
    end

    // RAM addresses - use lower bits of binary pointers
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Write enable to RAM
    wire wen = winc && !wfull;

    // Instantiate dual-port RAM submodule (assumed provided externally)
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram_inst (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(1'b1),   // Always enable read port
        .raddr(raddr),
        .rdata(rdata)
    );

endmodule
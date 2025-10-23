`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   wclk,
    input                   rclk,
    input                   wrstn,      // active low reset for write domain
    input                   rrstn,      // active low reset for read domain
    input                   winc,       // write increment (write enable)
    input                   rinc,       // read increment (read enable)
    input  [WIDTH-1:0]      wdata,      // data input
    output                  wfull,      // FIFO full flag
    output                  rempty,     // FIFO empty flag
    output [WIDTH-1:0]      rdata       // data output
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // Write and read pointer binary counters
    reg [PTR_WIDTH-1:0] wptr_bin, rptr_bin;
    wire [PTR_WIDTH-1:0] wptr_bin_next = wptr_bin + (winc && !wfull);
    wire [PTR_WIDTH-1:0] rptr_bin_next = rptr_bin + (rinc && !rempty);

    // Functions to convert binary <-> Gray code
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] b);
        bin2gray = (b >> 1) ^ b;
    endfunction

    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] g);
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = g[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i -1)
                gray2bin[i] = gray2bin[i+1] ^ g[i];
        end
    endfunction

    wire [PTR_WIDTH-1:0] wptr_gray = bin2gray(wptr_bin);
    wire [PTR_WIDTH-1:0] rptr_gray = bin2gray(rptr_bin);

    // Synchronize read pointer into write clock domain (2-stage)
    reg [PTR_WIDTH-1:0] rptr_gray_sync1_wclk, rptr_gray_sync2_wclk;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_sync1_wclk <= 0;
            rptr_gray_sync2_wclk <= 0;
        end else begin
            rptr_gray_sync1_wclk <= rptr_gray;
            rptr_gray_sync2_wclk <= rptr_gray_sync1_wclk;
        end
    end

    // Synchronize write pointer into read clock domain (2-stage)
    reg [PTR_WIDTH-1:0] wptr_gray_sync1_rclk, wptr_gray_sync2_rclk;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_sync1_rclk <= 0;
            wptr_gray_sync2_rclk <= 0;
        end else begin
            wptr_gray_sync1_rclk <= wptr_gray;
            wptr_gray_sync2_rclk <= wptr_gray_sync1_rclk;
        end
    end

    // Convert synchronized pointers back to binary
    wire [PTR_WIDTH-1:0] rptr_bin_sync = gray2bin(rptr_gray_sync2_wclk);
    wire [PTR_WIDTH-1:0] wptr_bin_sync = gray2bin(wptr_gray_sync2_rclk);

    // Generate full flag:
    // FIFO is full when next write pointer equals read pointer with MSBs inverted
    wire full_flag = ( (wptr_gray[PTR_WIDTH-1]   == ~rptr_gray_sync2_wclk[PTR_WIDTH-1]) &&
                       (wptr_gray[PTR_WIDTH-2]   == ~rptr_gray_sync2_wclk[PTR_WIDTH-2]) &&
                       (wptr_gray[PTR_WIDTH-3:0] ==  rptr_gray_sync2_wclk[PTR_WIDTH-3:0]) );

    // Generate empty flag:
    // FIFO is empty when read pointer equals synchronized write pointer
    wire empty_flag = (rptr_gray == wptr_gray_sync2_rclk);

    assign wfull = full_flag;
    assign rempty = empty_flag;

    // Update write pointer
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wptr_bin <= 0;
        else
            wptr_bin <= wptr_bin_next;
    end

    // Update read pointer
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rptr_bin <= 0;
        else
            rptr_bin <= rptr_bin_next;
    end

    // RAM address is lower bits of binary pointers
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;

    // Instantiate the dual-port RAM (external)
    wire [WIDTH-1:0] ram_rdata;

    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram_inst (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr),
        .rdata(ram_rdata)
    );

    assign rdata = ram_rdata;

endmodule
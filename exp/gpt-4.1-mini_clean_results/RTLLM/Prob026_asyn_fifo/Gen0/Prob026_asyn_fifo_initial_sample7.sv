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
    output                  wfull,
    output                  rempty,
    output [WIDTH-1:0]      rdata
);

    // Calculate address width based on DEPTH
    localparam ADDR_WIDTH = $clog2(DEPTH);
    // Pointer width: Use at least 4 bits for DEPTH=16 (to follow example with 4-bit Gray code)
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // Dual-port RAM instance
    wire wen = winc & ~wfull;
    wire ren = rinc & ~rempty;

    // Write and read address (binary)
    reg [PTR_WIDTH-1:0] waddr_bin;
    reg [PTR_WIDTH-1:0] raddr_bin;

    // Write and read Gray pointers
    reg [PTR_WIDTH-1:0] wptr, rptr;

    // Synchronized pointers across clock domains
    reg [PTR_WIDTH-1:0] rptr_sync1_wclk, rptr_sync2_wclk;
    reg [PTR_WIDTH-1:0] wptr_sync1_rclk, wptr_sync2_rclk;

    // Binary version of synchronized pointers
    wire [PTR_WIDTH-1:0] rptr_syn_bin_wclk;
    wire [PTR_WIDTH-1:0] wptr_syn_bin_rclk;

    // RAM ports addresses: lower ADDR_WIDTH bits of binary pointers
    wire [ADDR_WIDTH-1:0] waddr = waddr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = raddr_bin[ADDR_WIDTH-1:0];

    // Convert binary to Gray
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        bin2gray = (bin >> 1) ^ bin;
    endfunction

    // Convert Gray to binary
    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        reg [PTR_WIDTH-1:0] bin_tmp;
    begin
        bin_tmp[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
        for (i=PTR_WIDTH-2; i>=0; i=i-1)
            bin_tmp[i] = bin_tmp[i+1] ^ gray[i];
        gray2bin = bin_tmp;
    end
    endfunction

    // Write pointer binary counter and gray code
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            waddr_bin <= 0;
            wptr <= 0;
        end else begin
            if (wen) begin
                waddr_bin <= waddr_bin + 1;
                wptr <= bin2gray(waddr_bin + 1);
            end else begin
                wptr <= bin2gray(waddr_bin);
            end
        end
    end

    // Read pointer binary counter and gray code
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            raddr_bin <= 0;
            rptr <= 0;
        end else begin
            if (ren) begin
                raddr_bin <= raddr_bin + 1;
                rptr <= bin2gray(raddr_bin + 1);
            end else begin
                rptr <= bin2gray(raddr_bin);
            end
        end
    end

    // Synchronize read pointer into write clock domain (two-stage synchronizer)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_sync1_wclk <= 0;
            rptr_sync2_wclk <= 0;
        end else begin
            rptr_sync1_wclk <= rptr;
            rptr_sync2_wclk <= rptr_sync1_wclk;
        end
    end

    // Synchronize write pointer into read clock domain (two-stage synchronizer)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_sync1_rclk <= 0;
            wptr_sync2_rclk <= 0;
        end else begin
            wptr_sync1_rclk <= wptr;
            wptr_sync2_rclk <= wptr_sync1_rclk;
        end
    end

    // Convert synchronized Gray pointers back to binary
    assign rptr_syn_bin_wclk = gray2bin(rptr_sync2_wclk);
    assign wptr_syn_bin_rclk = gray2bin(wptr_sync2_rclk);

    // Generate full signal (write side)
    // Full when:
    // wptr_gray == {~rptr_gray[PTR_WIDTH-1:PTR_WIDTH-2], rptr_gray[PTR_WIDTH-3:0]}
    wire [PTR_WIDTH-1:0] rptr_gray = rptr_sync2_wclk;
    wire full_condition = (wptr == {~rptr_gray[PTR_WIDTH-1], ~rptr_gray[PTR_WIDTH-2], rptr_gray[PTR_WIDTH-3:0]});
    assign wfull = full_condition;

    // Generate empty signal (read side)
    // Empty when read pointer == synchronized write pointer
    assign rempty = (rptr == wptr_sync2_rclk);

    // Instantiate dual-port RAM
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_dual_port_RAM (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr),
        .rdata(rdata)
    );

endmodule


module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                       wclk,
    input                       wenc,
    input       [$clog2(DEPTH)-1:0] waddr,
    input       [WIDTH-1:0]     wdata,
    input                       rclk,
    input                       renc,
    input       [$clog2(DEPTH)-1:0] raddr,
    output reg  [WIDTH-1:0]     rdata
);

    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

    // Write operation
    always @(posedge wclk) begin
        if (wenc)
            RAM_MEM[waddr] <= wdata;
    end

    // Read operation
    always @(posedge rclk) begin
        if (renc)
            rdata <= RAM_MEM[raddr];
    end

endmodule
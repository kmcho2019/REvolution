`timescale 1ns / 1ps

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  wire                 wclk,
    input  wire                 rclk,
    input  wire                 wrstn,
    input  wire                 rrstn,
    input  wire                 winc,
    input  wire                 rinc,
    input  wire [WIDTH-1:0]     wdata,
    output wire                 wfull,
    output wire                 rempty,
    output wire [WIDTH-1:0]     rdata
);

// Calculate pointer width based on DEPTH (assumed power of two)
localparam PTR_WIDTH = $clog2(DEPTH);

//-------------------
// Dual Port RAM Module
//-------------------
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH)
) (
    input                  wclk,
    input                  wenc,
    input  [ADDR_WIDTH-1:0] waddr,
    input  [WIDTH-1:0]     wdata,
    input                  rclk,
    input                  renc,
    input  [ADDR_WIDTH-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);
    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    always @(posedge rclk) begin
        if (renc)
            rdata <= RAM_MEM[raddr];
    end
endmodule


//-------------------
// Binary to Gray code function
//-------------------
function [PTR_WIDTH:0] bin2gray;
    input [PTR_WIDTH:0] bin;
    integer i;
    begin
        bin2gray[PTR_WIDTH] = bin[PTR_WIDTH];
        for(i=PTR_WIDTH-1; i>=0; i=i-1) begin
            bin2gray[i] = bin[i+1] ^ bin[i];
        end
    end
endfunction

//-------------------
// Gray to Binary function
//-------------------
function [PTR_WIDTH:0] gray2bin;
    input [PTR_WIDTH:0] gray;
    integer i;
    begin
        gray2bin[PTR_WIDTH] = gray[PTR_WIDTH];
        for (i = PTR_WIDTH-1; i >= 0; i=i-1) begin
            gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    end
endfunction

//-------------------
// Write pointer (binary and gray), synchronizers, and write address
//-------------------
// Write pointer binary - PTR_WIDTH+1 bits wide for full detection MSBs
reg [PTR_WIDTH:0] wptr_bin;
reg [PTR_WIDTH:0] wptr_gray;

// Write pointer synchronization for read clock domain (used by read side)
reg [PTR_WIDTH:0] wptr_gray_rclk_1, wptr_gray_rclk_2;

always @(posedge wclk or negedge wrstn) begin
    if (!wrstn)
        wptr_bin <= 0;
    else if (winc && !wfull)
        wptr_bin <= wptr_bin + 1'b1;
end

always @(posedge wclk or negedge wrstn) begin
    if (!wrstn)
        wptr_gray <= 0;
    else
        wptr_gray <= bin2gray(wptr_bin);
end

// Synchronize write pointer into read clock domain
always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        wptr_gray_rclk_1 <= 0;
        wptr_gray_rclk_2 <= 0;
    end else begin
        wptr_gray_rclk_1 <= wptr_gray;
        wptr_gray_rclk_2 <= wptr_gray_rclk_1;
    end
end

// Write address for RAM access is lower bits of binary pointer
wire [PTR_WIDTH-1:0] waddr = wptr_bin[PTR_WIDTH-1:0];

//-------------------
// Read pointer (binary and gray), synchronizers, and read address
//-------------------
reg [PTR_WIDTH:0] rptr_bin;
reg [PTR_WIDTH:0] rptr_gray;

// Read pointer synchronization for write clock domain (used by write side)
reg [PTR_WIDTH:0] rptr_gray_wclk_1, rptr_gray_wclk_2;

always @(posedge rclk or negedge rrstn) begin
    if (!rrstn)
        rptr_bin <= 0;
    else if (rinc && !rempty)
        rptr_bin <= rptr_bin + 1'b1;
end

always @(posedge rclk or negedge rrstn) begin
    if (!rrstn)
        rptr_gray <= 0;
    else
        rptr_gray <= bin2gray(rptr_bin);
end

// Synchronize read pointer into write clock domain
always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        rptr_gray_wclk_1 <= 0;
        rptr_gray_wclk_2 <= 0;
    end else begin
        rptr_gray_wclk_1 <= rptr_gray;
        rptr_gray_wclk_2 <= rptr_gray_wclk_1;
    end
end

// Read address for RAM access is lower bits of binary pointer
wire [PTR_WIDTH-1:0] raddr = rptr_bin[PTR_WIDTH-1:0];

//-------------------
// Synchronize pointers converted back to binary for full/empty detection
//-------------------
wire [PTR_WIDTH:0] wptr_gray_sync_rclk = wptr_gray_rclk_2;
wire [PTR_WIDTH:0] rptr_gray_sync_wclk = rptr_gray_wclk_2;

wire [PTR_WIDTH:0] wptr_bin_sync_rclk = gray2bin(wptr_gray_sync_rclk);
wire [PTR_WIDTH:0] rptr_bin_sync_wclk = gray2bin(rptr_gray_sync_wclk);

//-------------------
// Full flag generation (write domain)
// Full when:
// wptr_bin + 1 == rptr_bin, but MSBs inverted
// Formula: When the next write pointer Gray code equals read pointer Gray code with top two bits inverted and the rest bits equal.
//-------------------
wire [PTR_WIDTH:0] wptr_bin_next = wptr_bin + 1'b1;
wire [PTR_WIDTH:0] wptr_gray_next = bin2gray(wptr_bin_next);

assign wfull = (wptr_gray_next[PTR_WIDTH]     == ~rptr_gray_sync_wclk[PTR_WIDTH]) &&
               (wptr_gray_next[PTR_WIDTH-1]   == ~rptr_gray_sync_wclk[PTR_WIDTH-1]) &&
               (wptr_gray_next[PTR_WIDTH-2:0] == rptr_gray_sync_wclk[PTR_WIDTH-2:0]);

//-------------------
// Empty flag generation (read domain)
// Empty when read pointer == synchronized write pointer
//-------------------
assign rempty = (rptr_gray == wptr_gray_sync_rclk);

//-------------------
// Write enable and read enable signals for dual-port RAM
//-------------------
wire wenc = winc & ~wfull;
wire renc = rinc & ~rempty;

//-------------------
// Instantiate dual-port RAM
//-------------------
dual_port_RAM #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH),
    .ADDR_WIDTH(PTR_WIDTH)
) ram (
    .wclk(wclk),
    .wenc(wenc),
    .waddr(waddr),
    .wdata(wdata),
    .rclk(rclk),
    .renc(renc),
    .raddr(raddr),
    .rdata(rdata)
);

endmodule
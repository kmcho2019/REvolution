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
    input  [WIDTH-1:0]      wdata,
    output                  wfull,
    output                  rempty,
    output [WIDTH-1:0]      rdata
);

// Calculate pointer width (number of bits to address DEPTH)
localparam PTR_WIDTH = $clog2(DEPTH);
localparam GRAY_WIDTH = PTR_WIDTH + 1;  // One extra bit for full detection

// Dual-port RAM module instantiation
// Ports: wclk, wenc, waddr, wdata, rclk, renc, raddr, rdata
wire wenc = winc & ~wfull;
wire renc = rinc & ~rempty;

// Binary write and read pointers (incremented in respective clock domains)
reg [PTR_WIDTH:0] waddr_bin; // extra bit for pointer wrap
reg [PTR_WIDTH:0] raddr_bin;

// Gray code pointers
reg [GRAY_WIDTH-1:0] wptr;
reg [GRAY_WIDTH-1:0] rptr;

// Pointer synchronizers
// Synchronize read pointer to write clock domain (2-stage synchronizer)
reg [GRAY_WIDTH-1:0] rptr_sync1_wclk, rptr_sync2_wclk;
// Synchronize write pointer to read clock domain (2-stage synchronizer)
reg [GRAY_WIDTH-1:0] wptr_sync1_rclk, wptr_sync2_rclk;

// Binary pointers converted from synchronized Gray pointers
wire [PTR_WIDTH:0] rptr_sync_bin;
wire [PTR_WIDTH:0] wptr_sync_bin;

// RAM address signals (using lower PTR_WIDTH bits of binary pointers)
wire [PTR_WIDTH-1:0] waddr_ram = waddr_bin[PTR_WIDTH-1:0];
wire [PTR_WIDTH-1:0] raddr_ram = raddr_bin[PTR_WIDTH-1:0];

// ---------------------------------------
// Dual Port RAM Submodule
// ---------------------------------------
dual_port_RAM #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
) ram_inst (
    .wclk(wclk),
    .wenc(wenc),
    .waddr(waddr_ram),
    .wdata(wdata),
    .rclk(rclk),
    .renc(renc),
    .raddr(raddr_ram),
    .rdata(rdata)
);

// ---------------------------------------
// Binary Pointer Increment & Reset Logic
// ---------------------------------------
always @(posedge wclk or negedge wrstn) begin
    if (!wrstn)
        waddr_bin <= 0;
    else if (winc & ~wfull)
        waddr_bin <= waddr_bin + 1'b1;
    else
        waddr_bin <= waddr_bin;
end

always @(posedge rclk or negedge rrstn) begin
    if (!rrstn)
        raddr_bin <= 0;
    else if (rinc & ~rempty)
        raddr_bin <= raddr_bin + 1'b1;
    else
        raddr_bin <= raddr_bin;
end

// ---------------------------------------
// Binary to Gray code conversion function
// ---------------------------------------
function [GRAY_WIDTH-1:0] bin2gray;
    input [GRAY_WIDTH-1:0] bin;
    integer i;
    begin
        bin2gray[GRAY_WIDTH-1] = bin[GRAY_WIDTH-1];
        for (i = GRAY_WIDTH-2; i >= 0; i = i - 1) begin
            bin2gray[i] = bin[i+1] ^ bin[i];
        end
    end
endfunction

// Convert binary pointers to Gray code
always @(posedge wclk or negedge wrstn) begin
    if (!wrstn)
        wptr <= 0;
    else
        wptr <= bin2gray(waddr_bin);
end

always @(posedge rclk or negedge rrstn) begin
    if (!rrstn)
        rptr <= 0;
    else
        rptr <= bin2gray(raddr_bin);
end

// ---------------------------------------
// Pointer synchronizers
// ---------------------------------------
// Synchronize read pointer into write clock domain
always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        rptr_sync1_wclk <= 0;
        rptr_sync2_wclk <= 0;
    end else begin
        rptr_sync1_wclk <= rptr;
        rptr_sync2_wclk <= rptr_sync1_wclk;
    end
end

// Synchronize write pointer into read clock domain
always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        wptr_sync1_rclk <= 0;
        wptr_sync2_rclk <= 0;
    end else begin
        wptr_sync1_rclk <= wptr;
        wptr_sync2_rclk <= wptr_sync1_rclk;
    end
end

// ---------------------------------------
// Gray to binary conversion function
// Reference: https://en.wikipedia.org/wiki/Gray_code#Converting_from_gray_code_to_binary
// ---------------------------------------
function [PTR_WIDTH:0] gray2bin;
    input [GRAY_WIDTH-1:0] gray;
    integer j;
    begin
        gray2bin[GRAY_WIDTH-1] = gray[GRAY_WIDTH-1];
        for (j = GRAY_WIDTH-2; j >= 0; j = j - 1) begin
            gray2bin[j] = gray2bin[j+1] ^ gray[j];
        end
    end
endfunction

assign rptr_sync_bin = gray2bin(rptr_sync2_wclk);
assign wptr_sync_bin = gray2bin(wptr_sync2_rclk);

// ---------------------------------------
// Full and Empty Logic
// ---------------------------------------
// Full when:
// write pointer's MSBs are inverse of read pointer's MSBs and remaining bits equal
// Specifically, for DEPTH=8 (PTR_WIDTH=3), GRAY_WIDTH=4,
// FIFO is full when:
// wptr[3:2] == ~rptr_sync2_wclk[3:2]
// and wptr[1:0] == rptr_sync2_wclk[1:0]
wire full_cond;

assign full_cond = ( (wptr[GRAY_WIDTH-1]         != rptr_sync2_wclk[GRAY_WIDTH-1]) &&
                     (wptr[GRAY_WIDTH-2]         != rptr_sync2_wclk[GRAY_WIDTH-2]) &&
                     (wptr[GRAY_WIDTH-3:0]       == rptr_sync2_wclk[GRAY_WIDTH-3:0]) );

// Empty when pointers are equal
wire empty_cond = (rptr == wptr_sync2_rclk);

assign wfull = full_cond;
assign rempty = empty_cond;

endmodule


// ---------------------------------------
// Dual Port RAM Module
// Asynchronous dual-port RAM with separate clocks and enables.
// Write side: wclk, wenc, waddr, wdata
// Read side : rclk, renc, raddr, rdata
// ---------------------------------------
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
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

// RAM memory array
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
    else
        rdata <= rdata; // hold last value when read not enabled
end

endmodule
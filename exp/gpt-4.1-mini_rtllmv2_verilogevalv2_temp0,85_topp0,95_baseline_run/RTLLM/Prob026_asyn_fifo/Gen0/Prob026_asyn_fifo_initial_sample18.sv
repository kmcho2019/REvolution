`timescale 1ns/1ps
module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    // internal parameter for address width based on DEPTH
    parameter ADDR_WIDTH = $clog2(DEPTH),
    parameter PTR_WIDTH = ADDR_WIDTH + 1 // one extra bit for full detection
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

// Dual-port RAM module instantiation
dual_port_RAM #(
    .DEPTH(DEPTH),
    .WIDTH(WIDTH)
) ram (
    .wclk   (wclk),
    .wenc   (winc && ~wfull),
    .waddr  (waddr_bin[ADDR_WIDTH-1:0]),
    .wdata  (wdata),
    .rclk   (rclk),
    .renc   (rinc && ~rempty),
    .raddr  (raddr_bin[ADDR_WIDTH-1:0]),
    .rdata  (rdata)
);

// Binary write and read pointers
reg [PTR_WIDTH-1:0] waddr_bin;
reg [PTR_WIDTH-1:0] raddr_bin;

// Gray code pointers
reg [PTR_WIDTH-1:0] wptr, rptr;

// Synchronizers for pointer crossing domains
reg [PTR_WIDTH-1:0] rptr_wclk_stage1, rptr_wclk_stage2; // read pointer into wclk domain
reg [PTR_WIDTH-1:0] wptr_rclk_stage1, wptr_rclk_stage2; // write pointer into rclk domain

// Synchronized pointers
wire [PTR_WIDTH-1:0] rptr_wclk; // read pointer synchronized to wclk
wire [PTR_WIDTH-1:0] wptr_rclk; // write pointer synchronized to rclk

assign rptr_wclk = rptr_wclk_stage2;
assign wptr_rclk = wptr_rclk_stage2;

// Binary to Gray code function
function [PTR_WIDTH-1:0] bin2gray;
    input [PTR_WIDTH-1:0] bin;
    integer i;
    begin
        bin2gray[PTR_WIDTH-1] = bin[PTR_WIDTH-1];
        for(i = PTR_WIDTH-2; i >= 0; i = i - 1) begin
            bin2gray[i] = bin[i+1] ^ bin[i];
        end
    end
endfunction

// Gray code to Binary function
function [PTR_WIDTH-1:0] gray2bin;
    input [PTR_WIDTH-1:0] gray;
    integer i;
    begin
        gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
        for(i = PTR_WIDTH-2; i >= 0; i = i - 1) begin
            gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    end
endfunction

// Write Pointer (Binary) and Gray pointer generation
always @(posedge wclk or negedge wrstn) begin
    if(!wrstn) begin
        waddr_bin <= 0;
        wptr <= 0;
    end else begin
        if (winc && !wfull) begin
            waddr_bin <= waddr_bin + 1;
        end
        wptr <= bin2gray(waddr_bin);
    end
end

// Read Pointer (Binary) and Gray pointer generation
always @(posedge rclk or negedge rrstn) begin
    if(!rrstn) begin
        raddr_bin <= 0;
        rptr <= 0;
    end else begin
        if (rinc && !rempty) begin
            raddr_bin <= raddr_bin + 1;
        end
        rptr <= bin2gray(raddr_bin);
    end
end

// Synchronize read pointer into write clock domain using two-stage synchronizer
always @(posedge wclk or negedge wrstn) begin
    if(!wrstn) begin
        rptr_wclk_stage1 <= 0;
        rptr_wclk_stage2 <= 0;
    end else begin
        rptr_wclk_stage1 <= rptr;
        rptr_wclk_stage2 <= rptr_wclk_stage1;
    end
end

// Synchronize write pointer into read clock domain using two-stage synchronizer
always @(posedge rclk or negedge rrstn) begin
    if(!rrstn) begin
        wptr_rclk_stage1 <= 0;
        wptr_rclk_stage2 <= 0;
    end else begin
        wptr_rclk_stage1 <= wptr;
        wptr_rclk_stage2 <= wptr_rclk_stage1;
    end
end

// Full and empty flag generation using Gray code pointer comparison
// Full condition:
// When write pointer is one ahead of read pointer with MSB and second MSB flipped:
// wfull = (wptr[PTR_WIDTH-1:PTR_WIDTH-2] == ~rptr_wclk[PTR_WIDTH-1:PTR_WIDTH-2]) and
//         (wptr[PTR_WIDTH-3:0] == rptr_wclk[PTR_WIDTH-3:0])
wire msb_inv_eq = (wptr[PTR_WIDTH-1:PTR_WIDTH-2] == ~rptr_wclk[PTR_WIDTH-1:PTR_WIDTH-2]);
wire lower_bits_eq = (wptr[PTR_WIDTH-3:0] == rptr_wclk[PTR_WIDTH-3:0]);
assign wfull = (msb_inv_eq && lower_bits_eq);

// Empty condition:
// FIFO empty when read pointer == write pointer synchronized into read domain
assign rempty = (rptr == wptr_rclk);

endmodule


// Dual-port RAM module
module dual_port_RAM #(
    parameter DEPTH = 16,
    parameter WIDTH = 8,
    parameter ADDR_WIDTH = $clog2(DEPTH)
) (
    input                       wclk,
    input                       wenc,
    input  [ADDR_WIDTH-1:0]     waddr,
    input  [WIDTH-1:0]          wdata,
    input                       rclk,
    input                       renc,
    input  [ADDR_WIDTH-1:0]     raddr,
    output reg [WIDTH-1:0]      rdata
);

    reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

    // Write operation
    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    // Read operation - data read register updated on rclk
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= RAM_MEM[raddr];
        end
    end

endmodule
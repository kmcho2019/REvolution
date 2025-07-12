module asyn_fifo(
    input  wclk, 
    input  rclk, 
    input  wrstn, 
    input  rrstn, 
    input  winc, 
    input  rinc, 
    input  [WIDTH-1:0] wdata, 
    output wfull, 
    output rempty, 
    output [WIDTH-1:0] rdata
);

parameter WIDTH = 8;
parameter DEPTH = 16;

// Dual-Port RAM Module
module dual_port_RAM(
    input  wclk, 
    input  wenc, 
    input  [$clog2(DEPTH)-1:0] waddr, 
    input  [WIDTH-1:0] wdata, 
    input  rclk, 
    input  renc, 
    input  [$clog2(DEPTH)-1:0] raddr, 
    output [WIDTH-1:0] rdata
);

reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

always @(posedge wclk) begin
    if (wenc) begin
        RAM_MEM[waddr] <= wdata;
    end
end

always @(posedge rclk) begin
    if (renc) begin
        rdata <= RAM_MEM[raddr];
    end
end

endmodule

// Gray Code Conversion
function [3:0] bin_to_gray;
    input [3:0] bin;
    begin
        bin_to_gray = bin ^ (bin >> 1);
    end
endfunction

function [3:0] gray_to_bin;
    input [3:0] gray;
    begin
        gray_to_bin = gray ^ (gray >> 1);
    end
endfunction

// Write Pointer Synchronization
reg [3:0] waddr_bin;
reg [3:0] wptr_buff;
reg [3:0] wptr_syn;

always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

always @(posedge wclk) begin
    wptr_buff <= waddr_bin;
end

always @(posedge rclk) begin
    wptr_syn <= wptr_buff;
end

// Read Pointer Synchronization
reg [3:0] raddr_bin;
reg [3:0] rptr_buff;
reg [3:0] rptr_syn;

always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

always @(posedge rclk) begin
    rptr_buff <= raddr_bin;
end

always @(posedge wclk) begin
    rptr_syn <= rptr_buff;
end

// FIFO Control Logic
reg wenc;
reg renc;
reg wfull;
reg rempty;

assign wenc = winc;
assign renc = rinc;

always @(posedge wclk) begin
    if (wptr_syn == (rptr_syn ^ 8'h8)) begin
        wfull <= 1'b1;
    end else begin
        wfull <= 1'b0;
    end
end

always @(posedge rclk) begin
    if (rptr_syn == wptr_syn) begin
        rempty <= 1'b1;
    end else begin
        rempty <= 1'b0;
    end
end

// Instantiate Dual-Port RAM
dual_port_RAM RAM(
    .wclk(wclk), 
    .wenc(wenc), 
    .waddr(gray_to_bin(bin_to_gray(waddr_bin))), 
    .wdata(wdata), 
    .rclk(rclk), 
    .renc(renc), 
    .raddr(gray_to_bin(bin_to_gray(raddr_bin))), 
    .rdata(rdata)
);

endmodule
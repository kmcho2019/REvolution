module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input wclk,
    input rclk,
    input wrstn,
    input rrstn,
    input winc,
    input rinc,
    input [WIDTH-1:0] wdata,
    output wfull,
    output rempty,
    output [WIDTH-1:0] rdata
);

// Dual-port RAM
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input wclk,
    input wenc,
    input [$clog2(DEPTH)-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input renc,
    input [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0] rdata
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

// Gray code conversion
function [3:0] bin_to_gray;
input [3:0] bin;
begin
    bin_to_gray = (bin >> 1) ^ bin;
end
endfunction

function [3:0] gray_to_bin;
input [3:0] gray;
reg [3:0] bin;
begin
    bin[0] = gray[0];
    bin[1] = gray[1] ^ bin[0];
    bin[2] = gray[2] ^ bin[1];
    bin[3] = gray[3] ^ bin[2];
    gray_to_bin = bin;
end
endfunction

// Asynchronous FIFO
reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];
reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] raddr_bin;
reg [3:0] wptr;
reg [3:0] rptr;
reg [3:0] wptr_buff;
reg [3:0] rptr_buff;
reg wfull_int;
reg rempty_int;

// Dual-port RAM instantiation
dual_port_RAM #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
) u_ram (
    .wclk(wclk),
    .wenc(winc),
    .waddr(waddr_bin),
    .wdata(wdata),
    .rclk(rclk),
    .renc(rinc),
    .raddr(raddr_bin),
    .rdata(rdata)
);

// Write pointer logic
always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
        wptr <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
        wptr <= bin_to_gray(waddr_bin);
    end
end

// Read pointer logic
always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
        rptr <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
        rptr <= bin_to_gray(raddr_bin);
    end
end

// Write pointer synchronizer
always @(posedge rclk) begin
    wptr_buff <= wptr;
end

// Read pointer synchronizer
always @(posedge wclk) begin
    rptr_buff <= rptr;
end

// Full and empty signal generation
always @(posedge wclk) begin
    if (wptr == (rptr_buff[3] ^ 1) + {rptr_buff[2:0]}) begin
        wfull_int <= 1;
    end else begin
        wfull_int <= 0;
    end
end

always @(posedge rclk) begin
    if (rptr == wptr_buff) begin
        rempty_int <= 1;
    end else begin
        rempty_int <= 0;
    end
end

assign wfull = wfull_int;
assign rempty = rempty_int;

endmodule
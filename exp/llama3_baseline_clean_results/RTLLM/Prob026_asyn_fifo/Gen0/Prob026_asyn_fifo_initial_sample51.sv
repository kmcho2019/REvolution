module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
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

// Dual-port RAM module
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
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

// Gray code conversion function
function [WIDTH-1:0] gray_code_bin_to_gray;
    input [WIDTH-1:0] bin;
    begin
        gray_code_bin_to_gray = (bin >> 1) ^ bin;
    end
endfunction

// Module implementation
reg [WIDTH-1:0] wptr;
reg [WIDTH-1:0] rptr;
reg [WIDTH-1:0] wptr_buff;
reg [WIDTH-1:0] rptr_buff;
reg [WIDTH-1:0] wptr_syn;
reg [WIDTH-1:0] rptr_syn;
reg [WIDTH-1:0] waddr_bin;
reg [WIDTH-1:0] raddr_bin;
reg wfull_int;
reg rempty_int;

// Write pointer logic
always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

// Read pointer logic
always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

// Gray code conversion
always @(posedge wclk) begin
    wptr_buff <= gray_code_bin_to_gray(waddr_bin);
end

always @(posedge rclk) begin
    rptr_buff <= gray_code_bin_to_gray(raddr_bin);
end

// Two-stage trigger for write pointer
always @(posedge wclk) begin
    wptr_syn <= wptr_buff;
end

// Two-stage trigger for read pointer
always @(posedge rclk) begin
    rptr_syn <= rptr_buff;
end

// Full and empty signals
always @(posedge wclk) begin
    wfull_int <= (wptr_syn == (~rptr_syn[WIDTH-1] ^ rptr_syn));
end

always @(posedge rclk) begin
    rempty_int <= (rptr_syn == wptr_syn);
end

// Dual-port RAM instantiation
dual_port_RAM #(.WIDTH(WIDTH), .DEPTH(DEPTH)) RAM (
    .wclk(wclk),
    .wenc(winc),
    .waddr(waddr_bin[$clog2(DEPTH)-1:0]),
    .wdata(wdata),
    .rclk(rclk),
    .renc(rinc),
    .raddr(raddr_bin[$clog2(DEPTH)-1:0]),
    .rdata(rdata)
);

// Output signals
assign wfull = wfull_int;
assign rempty = rempty_int;

endmodule
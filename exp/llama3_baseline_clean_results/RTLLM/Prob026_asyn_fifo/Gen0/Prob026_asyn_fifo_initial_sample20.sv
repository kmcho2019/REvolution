// Define the asyn_fifo module
module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wclk, // Write clock signal
    input rclk, // Read clock signal
    input wrstn, // Write reset signal
    input rrstn, // Read reset signal
    input winc, // Write increment signal
    input rinc, // Read increment signal
    input [WIDTH-1:0] wdata, // Write data input
    output wfull, // Write full signal
    output rempty, // Read empty signal
    output [WIDTH-1:0] rdata // Read data output
);

// Calculate the width of the address bus
localparam ADDR_WIDTH = $clog2(DEPTH);

// Define the dual-port RAM module
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = 4
)(
    input wclk, // Write clock signal
    input wenc, // Write enable signal
    input [ADDR_WIDTH-1:0] waddr, // Write address
    input [WIDTH-1:0] wdata, // Write data input
    input rclk, // Read clock signal
    input renc, // Read enable signal
    input [ADDR_WIDTH-1:0] raddr, // Read address
    output [WIDTH-1:0] rdata // Read data output
);
    reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0]; // RAM memory

    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    always @(posedge rclk) begin
        rdata <= RAM_MEM[raddr];
    end
endmodule

// Define the Gray code conversion function
function [ADDR_WIDTH-1:0] gray_to_bin(input [ADDR_WIDTH-1:0] gray);
    reg [ADDR_WIDTH-1:0] bin;
    bin = gray ^ (gray >> 1);
    return bin;
endfunction

// Define the binary to Gray code conversion function
function [ADDR_WIDTH-1:0] bin_to_gray(input [ADDR_WIDTH-1:0] bin);
    reg [ADDR_WIDTH-1:0] gray;
    gray = bin ^ (bin >> 1);
    return gray;
endfunction

// Define the write pointer register
reg [ADDR_WIDTH-1:0] waddr_bin;
reg [ADDR_WIDTH-1:0] wptr;
reg [ADDR_WIDTH-1:0] wptr_buff;

// Define the read pointer register
reg [ADDR_WIDTH-1:0] raddr_bin;
reg [ADDR_WIDTH-1:0] rptr;
reg [ADDR_WIDTH-1:0] rptr_buff;
reg [ADDR_WIDTH-1:0] rptr_syn;

// Instantiate the dual-port RAM module
dual_port_RAM #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH),
    .ADDR_WIDTH(ADDR_WIDTH)
) u_dual_port_RAM (
    .wclk(wclk),
    .wenc(winc),
    .waddr(waddr_bin[ADDR_WIDTH-2:0]),
    .wdata(wdata),
    .rclk(rclk),
    .renc(rinc),
    .raddr(raddr_bin[ADDR_WIDTH-2:0]),
    .rdata(rdata)
);

// Write pointer logic
always @(posedge wclk) begin
    if (!wrstn) begin
        waddr_bin <= 0;
        wptr_buff <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
        wptr <= bin_to_gray(waddr_bin);
        wptr_buff <= wptr;
    end
end

// Read pointer logic
always @(posedge rclk) begin
    if (!rrstn) begin
        raddr_bin <= 0;
        rptr_buff <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
        rptr <= bin_to_gray(raddr_bin);
        rptr_buff <= rptr;
    end
end

// Read pointer synchronizer
always @(posedge wclk) begin
    rptr_syn <= rptr_buff;
end

// Full and empty signals
assign wfull = (wptr == {~rptr_syn[ADDR_WIDTH-1], rptr_syn[ADDR_WIDTH-2:0]});
assign rempty = (rptr == wptr_buff);

endmodule
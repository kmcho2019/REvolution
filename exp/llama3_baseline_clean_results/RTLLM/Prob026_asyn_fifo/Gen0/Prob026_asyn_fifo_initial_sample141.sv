// Asynchronous FIFO module
module asyn_fifo(
    input wclk,  // Write clock signal
    input rclk,  // Read clock signal
    input wrstn, // Write reset signal
    input rrstn, // Read reset signal
    input winc,  // Write increment signal
    input rinc,  // Read increment signal
    input [7:0] wdata, // Write data input
    output reg wfull, // Write full signal
    output reg rempty, // Read empty signal
    output reg [7:0] rdata // Read data output
);

// Define the parameters
parameter DEPTH = 16;
parameter WIDTH = 8;

// Define the dual-port RAM module
module dual_port_RAM(
    input wclk,  // Write clock signal
    input wenc,  // Write enable signal
    input [$clog2(DEPTH)-1:0] waddr, // Write address
    input [WIDTH-1:0] wdata, // Write data
    input rclk,  // Read clock signal
    input renc,  // Read enable signal
    input [$clog2(DEPTH)-1:0] raddr, // Read address
    output reg [WIDTH-1:0] rdata // Read data output
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

// Define the Gray code conversion function
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
    bin = gray;
    for (int i = 0; i < 4; i++) begin
        bin = (bin >> 1) ^ bin;
    end
    gray_to_bin = bin;
end
endfunction

// Define the write pointer logic
reg [3:0] waddr_bin;
reg [3:0] wptr;
reg [3:0] wptr_buff;

always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

always @(posedge wclk) begin
    wptr <= bin_to_gray(waddr_bin);
end

always @(posedge wclk) begin
    wptr_buff <= wptr;
end

// Define the read pointer logic
reg [3:0] raddr_bin;
reg [3:0] rptr;
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
    rptr <= bin_to_gray(raddr_bin);
end

always @(posedge wclk) begin
    rptr_syn <= bin_to_gray(gray_to_bin(rptr));
end

always @(posedge wclk) begin
    rptr_buff <= rptr_syn;
end

// Define the full and empty signals
always @(posedge wclk) begin
    if (wptr == (~rptr_syn[3] & {1'b0, rptr_syn[2:0]})) begin
        wfull <= 1'b1;
    end else begin
        wfull <= 1'b0;
    end
end

always @(posedge rclk) begin
    if (rptr == wptr_buff) begin
        rempty <= 1'b1;
    end else begin
        rempty <= 1'b0;
    end
end

// Instantiate the dual-port RAM module
dual_port_RAM u_ram(
    .wclk(wclk),
    .wenc(winc),
    .waddr(waddr_bin[2:0]),
    .wdata(wdata),
    .rclk(rclk),
    .renc(rinc),
    .raddr(rptr_syn[2:0]),
    .rdata(rdata)
);

endmodule
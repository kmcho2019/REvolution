module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input wclk,  // Write clock signal
    input rclk,  // Read clock signal
    input wrstn, // Write reset signal
    input rrstn, // Read reset signal
    input winc,  // Write increment signal
    input rinc,  // Read increment signal
    input [WIDTH-1:0] wdata, // Write data input
    output reg wfull, // Write full signal
    output reg rempty, // Read empty signal
    output reg [WIDTH-1:0] rdata  // Read data output
);

// Dual-port RAM module
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input wclk,  // Write clock signal
    input wenc,  // Write enable signal
    input [$clog2(DEPTH)-1:0] waddr, // Write address
    input [WIDTH-1:0] wdata, // Write data input
    input rclk,  // Read clock signal
    input renc,  // Read enable signal
    input [$clog2(DEPTH)-1:0] raddr, // Read address
    output reg [WIDTH-1:0] rdata  // Read data output
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

// Dual-port RAM instantiation
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
   .rdata(rdata)
);

// Signals and variables
reg [WIDTH-1:0] wen; // Write enable signal
reg [WIDTH-1:0] ren; // Read enable signal
reg [$clog2(DEPTH)-1:0] waddr; // Write address
reg [$clog2(DEPTH)-1:0] raddr; // Read address
reg [$clog2(DEPTH)-1:0] waddr_bin; // Binary write address
reg [$clog2(DEPTH)-1:0] raddr_bin; // Binary read address
reg [$clog2(DEPTH)-1:0] wptr; // Write pointer (Gray code)
reg [$clog2(DEPTH)-1:0] rptr; // Read pointer (Gray code)
reg [$clog2(DEPTH)-1:0] wptr_buff; // Write pointer buffer
reg [$clog2(DEPTH)-1:0] rptr_buff; // Read pointer buffer
reg [$clog2(DEPTH)-1:0] wptr_syn; // Synchronized write pointer
reg [$clog2(DEPTH)-1:0] rptr_syn; // Synchronized read pointer

// Write and read pointer logic
always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

// Gray code conversion
always @(posedge wclk) begin
    wptr <= waddr_bin ^ (waddr_bin >> 1);
end

always @(posedge rclk) begin
    rptr <= raddr_bin ^ (raddr_bin >> 1);
end

// Pointer buffers
always @(posedge wclk) begin
    if (~wrstn) begin
        wptr_buff <= 0;
    end else begin
        wptr_buff <= wptr;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        rptr_buff <= 0;
    end else begin
        rptr_buff <= rptr;
    end
end

// Synchronized pointers
always @(posedge rclk) begin
    wptr_syn <= wptr_buff;
end

always @(posedge wclk) begin
    rptr_syn <= rptr_buff;
end

// Full and empty signals
always @(posedge wclk) begin
    if (wptr == {~rptr_syn[$clog2(DEPTH)-1], rptr_syn[$clog2(DEPTH)-2:0]}) begin
        wfull <= 1;
    end else begin
        wfull <= 0;
    end
end

always @(posedge rclk) begin
    if (rptr == wptr_syn) begin
        rempty <= 1;
    end else begin
        rempty <= 0;
    end
end

// Input and output connections
assign waddr = waddr_bin[$clog2(DEPTH)-1:1];
assign raddr = raddr_bin[$clog2(DEPTH)-1:1];
assign wen = winc;
assign ren = rinc;

endmodule
module asyn_fifo #
(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)
(
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

// Define the Gray code width
localparam GRAY_WIDTH = $clog2(DEPTH) + 1;

// Define the dual-port RAM module
module dual_port_RAM #
(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)
(
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

// Instantiate the dual-port RAM module
dual_port_RAM #(.WIDTH(WIDTH), .DEPTH(DEPTH)) dual_port_RAM_inst (
    .wclk(wclk),
    .wenc(wen),
    .waddr(waddr_bin),
    .wdata(wdata),
    .rclk(rclk),
    .renc(ren),
    .raddr(raddr_bin),
    .rdata(rdata)
);

// Define the write and read pointers
reg [GRAY_WIDTH-1:0] wptr;
reg [GRAY_WIDTH-1:0] rptr;
reg [GRAY_WIDTH-1:0] wptr_syn;
reg [GRAY_WIDTH-1:0] rptr_syn;

// Define the buffer registers for the write and read pointers
reg [GRAY_WIDTH-1:0] wptr_buff;
reg [GRAY_WIDTH-1:0] rptr_buff;

// Define the binary registers for the write and read pointers
reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] raddr_bin;

// Convert the binary pointers to Gray code
always @(posedge wclk) begin
    wptr <= waddr_bin ^ (waddr_bin >> 1);
end

always @(posedge rclk) begin
    rptr <= raddr_bin ^ (raddr_bin >> 1);
end

// Synchronize the write pointer
always @(posedge rclk) begin
    wptr_syn <= wptr_buff;
end

// Synchronize the read pointer
always @(posedge wclk) begin
    rptr_syn <= rptr_buff;
end

// Update the buffer registers
always @(posedge wclk) begin
    if (~wrstn) begin
        wptr_buff <= 0;
    end else if (winc) begin
        wptr_buff <= wptr;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        rptr_buff <= 0;
    end else if (rinc) begin
        rptr_buff <= rptr;
    end
end

// Update the binary pointers
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

// Generate the full and empty signals
assign wfull = (wptr_syn == (~rptr_syn[GRAY_WIDTH-1] & rptr_syn[GRAY_WIDTH-2:0]));
assign rempty = (rptr_syn == wptr_syn);

// Control the write and read enable signals
reg wen;
reg ren;

always @(posedge wclk) begin
    if (~wrstn) begin
        wen <= 0;
    end else if (winc) begin
        wen <= 1;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        ren <= 0;
    end else if (rinc) begin
        ren <= 1;
    end
end

endmodule
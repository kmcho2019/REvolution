// asyn_fifo module
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

// Define the width of the address bus
localparam ADDR_WIDTH = $clog2(DEPTH);

// Instantiate the dual-port RAM submodule
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

// Define the write and read pointers
reg [ADDR_WIDTH-1:0] waddr_bin;
reg [ADDR_WIDTH-1:0] raddr_bin;

// Define the Gray code conversion registers
reg [ADDR_WIDTH-1:0] wptr;
reg [ADDR_WIDTH-1:0] rptr;
reg [ADDR_WIDTH-1:0] wptr_buff;
reg [ADDR_WIDTH-1:0] rptr_buff;
reg [ADDR_WIDTH-1:0] rptr_syn;

// Define the write and read enable signals
reg wen;
reg ren;

// Initialize the write and read pointers
initial begin
    waddr_bin = 0;
    raddr_bin = 0;
    wptr = 0;
    rptr = 0;
    wptr_buff = 0;
    rptr_buff = 0;
    rptr_syn = 0;
    wen = 0;
    ren = 0;
end

// Write pointer logic
always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
        wptr <= 0;
        wptr_buff <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
        wptr <= {waddr_bin[ADDR_WIDTH-1], waddr_bin[ADDR_WIDTH-1] ^ waddr_bin[ADDR_WIDTH-2:0]};
        wptr_buff <= wptr;
    end
end

// Read pointer logic
always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
        rptr <= 0;
        rptr_buff <= 0;
        rptr_syn <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
        rptr <= {raddr_bin[ADDR_WIDTH-1], raddr_bin[ADDR_WIDTH-1] ^ raddr_bin[ADDR_WIDTH-2:0]};
        rptr_buff <= rptr;
    end
end

// Two-stage synchronizer for the read pointer
always @(posedge wclk) begin
    rptr_syn <= rptr_buff;
end

// Write enable logic
always @(posedge wclk) begin
    if (~wrstn) begin
        wen <= 0;
    end else if (winc) begin
        wen <= 1;
    end else begin
        wen <= 0;
    end
end

// Read enable logic
always @(posedge rclk) begin
    if (~rrstn) begin
        ren <= 0;
    end else if (rinc) begin
        ren <= 1;
    end else begin
        ren <= 0;
    end
end

// Full signal generation
assign wfull = (wptr == {~rptr_syn[ADDR_WIDTH-1], rptr_syn[ADDR_WIDTH-2:0]});

// Empty signal generation
assign rempty = (rptr == wptr);

// Assign the write and read addresses
assign waddr = waddr_bin[ADDR_WIDTH-2:0];
assign raddr = rptr_syn[ADDR_WIDTH-2:0];

endmodule

// Dual-port RAM submodule
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

// Define the RAM memory
reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

// Initialize the RAM memory
initial begin
    for (int i = 0; i < DEPTH; i++) begin
        RAM_MEM[i] = 0;
    end
end

// Write logic
always @(posedge wclk) begin
    if (wenc) begin
        RAM_MEM[waddr] <= wdata;
    end
end

// Read logic
always @(posedge rclk) begin
    if (renc) begin
        rdata <= RAM_MEM[raddr];
    end
end

endmodule
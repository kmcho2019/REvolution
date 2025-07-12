module asyn_fifo(
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

parameter DEPTH = 16;
parameter WIDTH = 8;

// Calculate the address width based on the depth
localparam ADDR_WIDTH = $clog2(DEPTH);

// Dual-port RAM submodule
dual_port_RAM #(
    .DEPTH(DEPTH), 
    .WIDTH(WIDTH)
) u_ram(
    .wclk(wclk), 
    .wenc(wen), 
    .waddr(waddr_bin[ADDR_WIDTH-1:0]), 
    .wdata(wdata), 
    .rclk(rclk), 
    .renc(ren), 
    .raddr(raddr_bin[ADDR_WIDTH-1:0]), 
    .rdata(rdata)
);

// Write pointer register
reg [ADDR_WIDTH-1:0] waddr_bin;
reg [ADDR_WIDTH-1:0] waddr_bin_buff;

// Read pointer register
reg [ADDR_WIDTH-1:0] raddr_bin;
reg [ADDR_WIDTH-1:0] raddr_bin_buff;

// Write and read enable signals
reg wen;
reg ren;

// Write and read pointer Gray code registers
reg [ADDR_WIDTH:0] wptr;
reg [ADDR_WIDTH:0] rptr;
reg [ADDR_WIDTH:0] wptr_syn;
reg [ADDR_WIDTH:0] rptr_syn;

// Initialize write and read pointers
initial begin
    waddr_bin = 0;
    raddr_bin = 0;
    wptr = 0;
    rptr = 0;
    wptr_syn = 0;
    rptr_syn = 0;
end

// Write pointer increment
always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

// Read pointer increment
always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        raddr_bin <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

// Write pointer buffer
always @(posedge wclk) begin
    waddr_bin_buff <= waddr_bin;
end

// Read pointer buffer
always @(posedge rclk) begin
    raddr_bin_buff <= raddr_bin;
end

// Gray code conversion for write pointer
always @(posedge wclk) begin
    wptr <= (waddr_bin >> 1) ^ waddr_bin;
end

// Gray code conversion for read pointer
always @(posedge rclk) begin
    rptr <= (raddr_bin >> 1) ^ raddr_bin;
end

// Write pointer synchronizer
reg [1:0] wptr_syn_reg;
always @(posedge rclk) begin
    wptr_syn_reg[0] <= wptr[ADDR_WIDTH];
    wptr_syn_reg[1] <= wptr_syn_reg[0];
    wptr_syn <= {wptr_syn_reg[1], wptr[ADDR_WIDTH-1:0]};
end

// Read pointer synchronizer
reg [1:0] rptr_syn_reg;
always @(posedge wclk) begin
    rptr_syn_reg[0] <= rptr[ADDR_WIDTH];
    rptr_syn_reg[1] <= rptr_syn_reg[0];
    rptr_syn <= {rptr_syn_reg[1], rptr[ADDR_WIDTH-1:0]};
end

// Write enable signal
assign wen = winc;

// Read enable signal
assign ren = rinc;

// Full signal generation
assign wfull = (wptr_syn[ADDR_WIDTH] != rptr[ADDR_WIDTH]) && (wptr_syn[ADDR_WIDTH-1:0] == rptr[ADDR_WIDTH-1:0]);

// Empty signal generation
assign rempty = (wptr_syn == rptr);

endmodule

module dual_port_RAM(
    input wclk, 
    input wenc, 
    input [ADDR_WIDTH-1:0] waddr, 
    input [WIDTH-1:0] wdata, 
    input rclk, 
    input renc, 
    input [ADDR_WIDTH-1:0] raddr, 
    output [WIDTH-1:0] rdata
);

parameter DEPTH = 16;
parameter WIDTH = 8;
localparam ADDR_WIDTH = $clog2(DEPTH);

reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

// Write operation
always @(posedge wclk) begin
    if (wenc) begin
        RAM_MEM[waddr] <= wdata;
    end
end

// Read operation
always @(posedge rclk) begin
    if (renc) begin
        rdata <= RAM_MEM[raddr];
    end
end

endmodule
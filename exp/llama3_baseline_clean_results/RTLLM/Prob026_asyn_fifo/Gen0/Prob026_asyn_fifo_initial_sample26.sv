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

// Local parameters
localparam ADDR_WIDTH = $clog2(DEPTH);

// Wire and reg declarations
wire [ADDR_WIDTH-1:0] waddr_bin, raddr_bin;
wire [ADDR_WIDTH-1:0] wptr_gray, rptr_gray;
reg [ADDR_WIDTH-1:0] wptr_bin, rptr_bin;
reg [ADDR_WIDTH-1:0] wptr_syn_bin, rptr_syn_bin;
reg wfull_reg, rempty_reg;
reg [WIDTH-1:0] rdata_reg;
wire wenc, renc;
wire [WIDTH-1:0] ram_rdata;

// Instantiate dual-port RAM
dual_port_RAM #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
) ram (
    .wclk(wclk),
    .rclk(rclk),
    .wenc(wenc),
    .renc(renc),
    .waddr(waddr_bin),
    .raddr(raddr_bin),
    .wdata(wdata),
    .rdata(ram_rdata)
);

// Write pointer counter
always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        wptr_bin <= 0;
    end else if (winc) begin
        wptr_bin <= wptr_bin + 1;
    end
end

// Read pointer counter
always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        rptr_bin <= 0;
    end else if (rinc) begin
        rptr_bin <= rptr_bin + 1;
    end
end

// Gray code conversion
assign wptr_gray = (wptr_bin >> 1) ^ wptr_bin;
assign rptr_gray = (rptr_bin >> 1) ^ rptr_bin;

// Write pointer synchronizer
reg [ADDR_WIDTH-1:0] wptr_syn1, wptr_syn2;
always @(posedge rclk) begin
    wptr_syn1 <= wptr_gray;
    wptr_syn2 <= wptr_syn1;
end
assign wptr_syn_bin = wptr_syn2;

// Read pointer synchronizer
reg [ADDR_WIDTH-1:0] rptr_syn1, rptr_syn2;
always @(posedge wclk) begin
    rptr_syn1 <= rptr_gray;
    rptr_syn2 <= rptr_syn1;
end
assign rptr_syn_bin = rptr_syn2;

// Address generation
assign waddr_bin = wptr_bin[ADDR_WIDTH-2:0];
assign raddr_bin = rptr_bin[ADDR_WIDTH-2:0];

// Empty and full signals generation
always @(posedge wclk) begin
    if (wptr_gray == {~rptr_syn_bin[ADDR_WIDTH-1], rptr_syn_bin[ADDR_WIDTH-2:0]}) begin
        wfull_reg <= 1;
    end else begin
        wfull_reg <= 0;
    end
end

always @(posedge rclk) begin
    if (rptr_gray == wptr_syn_bin) begin
        rempty_reg <= 1;
    end else begin
        rempty_reg <= 0;
    end
end

// Enable signals generation
assign wenc = winc;
assign renc = rinc;

// Output assignments
assign wfull = wfull_reg;
assign rempty = rempty_reg;
assign rdata = ram_rdata;

endmodule

module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wclk,
    input rclk,
    input wenc,
    input renc,
    input [$clog2(DEPTH)-1:0] waddr,
    input [$clog2(DEPTH)-1:0] raddr,
    input [WIDTH-1:0] wdata,
    output [WIDTH-1:0] rdata
);

// Local parameters
localparam ADDR_WIDTH = $clog2(DEPTH);

// Wire and reg declarations
reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];
reg [WIDTH-1:0] rdata_reg;

// Write operation
always @(posedge wclk) begin
    if (wenc) begin
        RAM_MEM[waddr] <= wdata;
    end
end

// Read operation
always @(posedge rclk) begin
    rdata_reg <= RAM_MEM[raddr];
end

// Output assignment
assign rdata = rdata_reg;

endmodule
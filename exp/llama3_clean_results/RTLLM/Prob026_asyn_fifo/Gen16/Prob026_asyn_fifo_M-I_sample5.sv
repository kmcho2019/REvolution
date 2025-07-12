// Asynchronous FIFO Module
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
    output reg wfull,
    output reg rempty,
    output reg [WIDTH-1:0] rdata
);

// Local Parameters
localparam ADDR_WIDTH = $clog2(DEPTH);
localparam GRAY_WIDTH = ADDR_WIDTH + 1;

// Dual-Port RAM Module
module dual_port_ram #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wclk,
    input wenc,
    input [ADDR_WIDTH-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input renc,
    input [ADDR_WIDTH-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);

reg [WIDTH-1:0] ram [DEPTH-1:0];

always @(posedge wclk) begin
    if (wenc) begin
        ram[waddr] <= wdata;
    end
end

always @(posedge rclk) begin
    if (renc) begin
        rdata <= ram[raddr];
    end
end

endmodule

// Instantiation of Dual-Port RAM Module
dual_port_ram #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
) u_ram (
    .wclk(wclk),
    .wenc(wenc),
    .waddr(waddr),
    .wdata(wdata),
    .rclk(rclk),
    .renc(renc),
    .raddr(raddr),
    .rdata(rdata)
);

// Write and Read Pointers
reg [ADDR_WIDTH-1:0] wptr;
reg [ADDR_WIDTH-1:0] rptr;

// Gray Code Conversion
reg [GRAY_WIDTH-1:0] wptr_gray;
reg [GRAY_WIDTH-1:0] rptr_gray;

always @(posedge wclk) begin
    wptr_gray <= {wptr[ADDR_WIDTH-1], wptr[ADDR_WIDTH-1:1] ^ wptr[ADDR_WIDTH-2:0]};
end

always @(posedge rclk) begin
    rptr_gray <= {rptr[ADDR_WIDTH-1], rptr[ADDR_WIDTH-1:1] ^ rptr[ADDR_WIDTH-2:0]};
end

// Write Controller
reg wenc;
always @(posedge wclk) begin
    if (~wrstn) begin
        wptr <= 0;
        wenc <= 0;
    end else if (winc) begin
        wptr <= (wptr + 1) % DEPTH;
        wenc <= 1;
    end else begin
        wenc <= 0;
    end
end

// Read Controller
reg renc;
always @(posedge rclk) begin
    if (~rrstn) begin
        rptr <= 0;
        renc <= 0;
    end else if (rinc) begin
        rptr <= (rptr + 1) % DEPTH;
        renc <= 1;
    end else begin
        renc <= 0;
    end
end

// Full and Empty Signal Generation
assign wfull = (wptr_gray == {~rptr_gray[GRAY_WIDTH-1], rptr_gray[GRAY_WIDTH-2:0]});
assign rempty = (rptr_gray == wptr_gray);

endmodule
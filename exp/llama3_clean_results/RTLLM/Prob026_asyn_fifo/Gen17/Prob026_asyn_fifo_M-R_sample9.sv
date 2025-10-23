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

// Dual-Port RAM Module
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

// Instantiation of Dual-Port RAM
dual_port_RAM #(.WIDTH(WIDTH), .DEPTH(DEPTH)) ram_inst (
    .wclk(wclk),
    .wenc(winc),
    .waddr(waddr),
    .wdata(wdata),
    .rclk(rclk),
    .renc(rinc),
    .raddr(raddr),
    .rdata(rdata)
);

// Write Pointer
reg [$clog2(DEPTH)-1:0] waddr;
reg [$clog2(DEPTH)-1:0] wptr;
reg [1:0] wgray;

// Read Pointer
reg [$clog2(DEPTH)-1:0] raddr;
reg [$clog2(DEPTH)-1:0] rptr;
reg [1:0] rgray;

// Gray Code Conversion
assign wgray[1] = wptr[1] ^ wptr[0];
assign wgray[0] = wptr[0];
assign rgray[1] = rptr[1] ^ rptr[0];
assign rgray[0] = rptr[0];

// Write Controller
always @(posedge wclk) begin
    if (~wrstn) begin
        wptr <= 0;
    end else if (winc) begin
        wptr <= (wptr + 1) % DEPTH;
    end
end

// Read Controller
always @(posedge rclk) begin
    if (~rrstn) begin
        rptr <= 0;
    end else if (rinc) begin
        rptr <= (rptr + 1) % DEPTH;
    end
end

// Read Pointer Synchronizer
reg [1:0] rptr_sync;
always @(posedge wclk) begin
    rptr_sync[1] <= rptr[1];
    rptr_sync[0] <= rptr_sync[1];
end

// Write Pointer Synchronizer
reg [1:0] wptr_sync;
always @(posedge rclk) begin
    wptr_sync[1] <= wptr[1];
    wptr_sync[0] <= wptr_sync[1];
end

// Full and Empty Signal Generation
assign wfull = (wptr == (rptr + 1) % DEPTH);
assign rempty = (rptr == wptr);

// Output Assignment
assign waddr = wptr[2:0];
assign raddr = rptr_sync[2:0];

endmodule
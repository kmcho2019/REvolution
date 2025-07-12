module asyn_fifo(
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

parameter WIDTH = 8;
parameter DEPTH = 16;
parameter GRAY_WIDTH = $clog2(DEPTH);

// Dual-port RAM
module dual_port_RAM(
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

// Write and Read Controllers
reg [GRAY_WIDTH-1:0] wptr;
reg [GRAY_WIDTH-1:0] rptr;
reg [GRAY_WIDTH-1:0] wptr_syn;
reg [GRAY_WIDTH-1:0] rptr_syn;
reg [WIDTH-1:0] rdata_reg;

always @(posedge wclk) begin
    if (~wrstn) begin
        wptr <= 0;
    end else if (winc) begin
        wptr <= wptr + 1;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        rptr <= 0;
    end else if (rinc) begin
        rptr <= rptr + 1;
    end
end

// Pointer Synchronizers
reg [GRAY_WIDTH-1:0] wptr_buff;
reg [GRAY_WIDTH-1:0] rptr_buff;

always @(posedge wclk) begin
    wptr_buff <= wptr;
end

always @(posedge rclk) begin
    rptr_buff <= rptr;
end

// Gray Code Conversion
always @(posedge wclk) begin
    wptr_syn <= {wptr_buff[GRAY_WIDTH-1], wptr_buff[GRAY_WIDTH-1:1]^wptr_buff[GRAY_WIDTH-2:0]};
end

always @(posedge rclk) begin
    rptr_syn <= {rptr_buff[GRAY_WIDTH-1], rptr_buff[GRAY_WIDTH-1:1]^rptr_buff[GRAY_WIDTH-2:0]};
end

// Full and Empty Signals
always @(posedge wclk) begin
    if (wptr_syn == {~rptr_syn[GRAY_WIDTH-1], rptr_syn[GRAY_WIDTH-2:0]}) begin
        wfull <= 1;
    end else begin
        wfull <= 0;
    end
end

always @(posedge rclk) begin
    if (rptr_syn == wptr_syn) begin
        rempty <= 1;
    end else begin
        rempty <= 0;
    end
end

// Input and Output Connections
dual_port_RAM u_ram(
   .wclk(wclk),
   .wenc(~wfull & winc),
   .waddr(wptr[GRAY_WIDTH-2:0]),
   .wdata(wdata),
   .rclk(rclk),
   .renc(~rempty & rinc),
   .raddr(rptr[GRAY_WIDTH-2:0]),
   .rdata(rdata_reg)
);

always @(posedge rclk) begin
    rdata <= rdata_reg;
end

endmodule
module asyn_fifo (
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

parameter WIDTH = 8;
parameter DEPTH = 16;

reg [WIDTH-1:0] ram_data;
reg wfull_reg, rempty_reg;
reg [WIDTH-1:0] rdata_reg;

wire [WIDTH-1:0] wdata_wire;
wire wfull_wire, rempty_wire;
wire [WIDTH-1:0] rdata_wire;

// Dual-port RAM module
dual_port_RAM ram (
   .wclk(wclk), 
   .wenc(winc), 
   .waddr(waddr_bin), 
   .wdata(wdata), 
   .rclk(rclk), 
   .renc(rinc), 
   .raddr(raddr_bin), 
   .rdata(rdata_wire)
);

// Write pointer binary register
reg [$clog2(DEPTH)-1:0] waddr_bin;
always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

// Read pointer binary register
reg [$clog2(DEPTH)-1:0] raddr_bin;
always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        raddr_bin <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

// Write pointer Gray code conversion
reg [$clog2(DEPTH)-1:0] wptr;
always @(posedge wclk) begin
    wptr <= waddr_bin ^ (waddr_bin >> 1);
end

// Read pointer Gray code conversion
reg [$clog2(DEPTH)-1:0] rptr;
always @(posedge rclk) begin
    rptr <= raddr_bin ^ (raddr_bin >> 1);
end

// Write pointer synchronizer
reg [$clog2(DEPTH)-1:0] wptr_syn;
always @(posedge rclk) begin
    wptr_syn <= wptr;
end

// Read pointer synchronizer
reg [$clog2(DEPTH)-1:0] rptr_syn;
always @(posedge wclk) begin
    rptr_syn <= rptr;
end

// Full and empty signals
assign wfull = (wptr_syn == {~rptr_syn[$clog2(DEPTH)-1], rptr_syn[$clog2(DEPTH)-2:0]});
assign rempty = (rptr_syn == wptr_syn);

// Output assignments
assign wfull_reg = wfull;
assign rempty_reg = rempty;
assign rdata_reg = rdata_wire;

assign wfull = wfull_reg;
assign rempty = rempty_reg;
assign rdata = rdata_reg;

endmodule

module dual_port_RAM (
    input wclk, 
    input wenc, 
    input [$clog2(DEPTH)-1:0] waddr, 
    input [WIDTH-1:0] wdata, 
    input rclk, 
    input renc, 
    input [$clog2(DEPTH)-1:0] raddr, 
    output reg [WIDTH-1:0] rdata
);

parameter WIDTH = 8;
parameter DEPTH = 16;

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
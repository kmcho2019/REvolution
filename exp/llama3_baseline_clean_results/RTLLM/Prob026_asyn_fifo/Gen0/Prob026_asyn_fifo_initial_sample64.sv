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

parameter DEPTH = 16;
parameter WIDTH = 8;

wire wenc, renc;
reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];
reg [$clog2(DEPTH)-1:0] waddr_bin, raddr_bin;
reg [$clog2(DEPTH)-1:0] wptr, rptr, wptr_syn, rptr_syn;
reg [WIDTH-1:0] rdata_reg;

// Dual-port RAM
dual_port_RAM dual_port_RAM_inst (
    .wclk(wclk), 
    .wenc(wenc), 
    .waddr(waddr_bin), 
    .wdata(wdata), 
    .rclk(rclk), 
    .renc(renc), 
    .raddr(raddr_bin), 
    .rdata(rdata_reg)
);

// Write Pointer
always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

// Read Pointer
always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        raddr_bin <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

// Gray Code Conversion for Write Pointer
always @(posedge wclk) begin
    wptr <= waddr_bin ^ (waddr_bin >> 1);
end

// Gray Code Conversion for Read Pointer
always @(posedge rclk) begin
    rptr <= raddr_bin ^ (raddr_bin >> 1);
end

// Write Pointer Synchronizer
reg [1:0] wptr_syn_reg;
always @(posedge rclk) begin
    wptr_syn_reg[0] <= wptr;
    wptr_syn_reg[1] <= wptr_syn_reg[0];
    wptr_syn <= wptr_syn_reg[1];
end

// Read Pointer Synchronizer
reg [1:0] rptr_syn_reg;
always @(posedge wclk) begin
    rptr_syn_reg[0] <= rptr;
    rptr_syn_reg[1] <= rptr_syn_reg[0];
    rptr_syn <= rptr_syn_reg[1];
end

// Full Signal
assign wfull = (wptr_syn == {~rptr[3], rptr[2:0]});

// Empty Signal
assign rempty = (rptr == wptr_syn);

// Write Enable
assign wenc = winc;

// Read Enable
assign renc = rinc;

// Read Data
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

parameter DEPTH = 16;
parameter WIDTH = 8;

reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

// Write Operation
always @(posedge wclk) begin
    if (wenc) begin
        RAM_MEM[waddr] <= wdata;
    end
end

// Read Operation
always @(posedge rclk) begin
    if (renc) begin
        rdata <= RAM_MEM[raddr];
    end
end

endmodule
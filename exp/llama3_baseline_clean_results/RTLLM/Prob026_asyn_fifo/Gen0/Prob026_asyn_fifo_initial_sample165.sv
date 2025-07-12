// Dual-port RAM module
module dual_port_RAM (
    input   wclk, 
    input   wenc, 
    input   [$clog2(DEPTH)-1:0] waddr, 
    input   [WIDTH-1:0] wdata, 
    input   rclk, 
    input   renc, 
    input   [$clog2(DEPTH)-1:0] raddr, 
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

// Asynchronous FIFO module
module asyn_fifo (
    input   wclk, 
    input   rclk, 
    input   wrstn, 
    input   rrstn, 
    input   winc, 
    input   rinc, 
    input   [WIDTH-1:0] wdata, 
    output reg  wfull, 
    output reg  rempty, 
    output reg [WIDTH-1:0] rdata
);

parameter DEPTH = 16;
parameter WIDTH = 8;

reg [$clog2(DEPTH)-1:0] waddr_bin, raddr_bin;
reg [$clog2(DEPTH)-1:0] wptr, rptr, rptr_syn, wptr_syn;

reg [WIDTH-1:0] rdata_reg;

// Dual-port RAM instantiation
dual_port_RAM u_ram (
    .wclk    (wclk), 
    .wenc    (1'b1), 
    .waddr   (waddr_bin), 
    .wdata   (wdata), 
    .rclk    (rclk), 
    .renc    (1'b1), 
    .raddr   (raddr_bin), 
    .rdata   (rdata_reg)
);

// Write pointer logic
always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

// Read pointer logic
always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

// Gray code conversion
always @(posedge wclk) begin
    wptr <= {waddr_bin[$clog2(DEPTH)-1], waddr_bin[$clog2(DEPTH)-1:$clog2(DEPTH)-2] ^ waddr_bin[$clog2(DEPTH)-2:0]};
end

always @(posedge rclk) begin
    rptr <= {raddr_bin[$clog2(DEPTH)-1], raddr_bin[$clog2(DEPTH)-1:$clog2(DEPTH)-2] ^ raddr_bin[$clog2(DEPTH)-2:0]};
end

// Read pointer synchronizer
reg [$clog2(DEPTH)-1:0] rptr_syn_reg1, rptr_syn_reg2;

always @(posedge wclk) begin
    rptr_syn_reg1 <= rptr;
    rptr_syn_reg2 <= rptr_syn_reg1;
end

assign rptr_syn = rptr_syn_reg2;

// Write pointer synchronizer
reg [$clog2(DEPTH)-1:0] wptr_syn_reg1, wptr_syn_reg2;

always @(posedge rclk) begin
    wptr_syn_reg1 <= wptr;
    wptr_syn_reg2 <= wptr_syn_reg1;
end

assign wptr_syn = wptr_syn_reg2;

// Full and empty signal detection
always @(posedge wclk) begin
    if (~wrstn) begin
        wfull <= 0;
    end else begin
        wfull <= (wptr_syn == {~rptr_syn[$clog2(DEPTH)-1], rptr_syn[$clog2(DEPTH)-2:0]});
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        rempty <= 1;
    end else begin
        rempty <= (rptr == wptr_syn);
    end
end

// Output assignment
always @(posedge rclk) begin
    rdata <= rdata_reg;
end

endmodule
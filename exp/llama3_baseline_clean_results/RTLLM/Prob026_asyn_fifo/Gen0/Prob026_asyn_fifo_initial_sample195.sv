module dual_port_RAM (
    input wclk,
    input wenc,
    input [3:0] waddr,
    input [7:0] wdata,
    input rclk,
    input renc,
    input [3:0] raddr,
    output reg [7:0] rdata
);

reg [7:0] RAM_MEM [15:0];

always @(posedge wclk) begin
    if (wenc) begin
        RAM_MEM[waddr] <= wdata;
    end
end

always @(posedge rclk) begin
    if (renc) begin
        rdata <= RAM_MEM[raddr];
    end else begin
        rdata <= 8'b0;
    end
end

endmodule

module asyn_fifo (
    input wclk,
    input rclk,
    input wrstn,
    input rrstn,
    input winc,
    input rinc,
    input [7:0] wdata,
    output reg wfull,
    output reg rempty,
    output reg [7:0] rdata
);

parameter WIDTH = 8;
parameter DEPTH = 16;

reg [3:0] waddr_bin;
reg [3:0] raddr_bin;
reg [3:0] wptr;
reg [3:0] rptr;
reg [3:0] wptr_buff;
reg [3:0] rptr_buff;
reg [3:0] wptr_syn;
reg [3:0] rptr_syn;
reg [7:0] rdata_reg;

dual_port_RAM ram_inst (
    .wclk(wclk),
    .wenc(wenc),
    .waddr(waddr_bin),
    .wdata(wdata),
    .rclk(rclk),
    .renc(renc),
    .raddr(raddr_bin),
    .rdata(rdata_reg)
);

assign wenc = winc & ~wfull;
assign renc = rinc & ~rempty;

always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 4'b0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 4'b0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

// Gray code conversion for write pointer
always @(posedge wclk) begin
    wptr <= waddr_bin ^ (waddr_bin >> 1);
end

// Gray code conversion for read pointer
always @(posedge rclk) begin
    rptr <= raddr_bin ^ (raddr_bin >> 1);
end

// Two-stage synchronizer for write pointer
always @(posedge rclk) begin
    wptr_buff <= wptr;
    wptr_syn <= wptr_buff;
end

// Two-stage synchronizer for read pointer
always @(posedge wclk) begin
    rptr_buff <= rptr;
    rptr_syn <= rptr_buff;
end

// Full and empty detection
always @(posedge wclk) begin
    if (wptr == {~rptr_syn[3], rptr_syn[2:0]}) begin
        wfull <= 1;
    end else begin
        wfull <= 0;
    end
end

always @(posedge rclk) begin
    if (rptr == wptr_syn) begin
        rempty <= 1;
    end else begin
        rempty <= 0;
    end
end

// Output assignment
assign rdata = rdata_reg;

endmodule
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

localparam ADDR_WIDTH = $clog2(DEPTH);

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
assign rdata = ram[raddr];

always @(posedge wclk) begin
    if (wenc) begin
        ram[waddr] <= wdata;
    end
end

endmodule

// Dual-Port RAM Instantiation
dual_port_ram #(
   .WIDTH(WIDTH),
   .DEPTH(DEPTH)
) dual_port_ram_inst (
   .wclk(wclk),
   .wenc(winc),
   .waddr(waddr_bin),
   .wdata(wdata),
   .rclk(rclk),
   .renc(rinc),
   .raddr(raddr_bin),
   .rdata(rdata)
);

// Write pointer update
reg [ADDR_WIDTH-1:0] waddr_bin;
reg [ADDR_WIDTH-1:0] wptr_gray;
always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        waddr_bin <= 0;
        wptr_gray <= 0;
    end else if (winc && ~wfull) begin
        waddr_bin <= (waddr_bin + 1) % DEPTH;
        wptr_gray <= waddr_bin ^ (waddr_bin >> 1);
    end
end

// Read pointer update
reg [ADDR_WIDTH-1:0] raddr_bin;
reg [ADDR_WIDTH-1:0] rptr_gray;
always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        raddr_bin <= 0;
        rptr_gray <= 0;
    end else if (rinc && ~rempty) begin
        raddr_bin <= (raddr_bin + 1) % DEPTH;
        rptr_gray <= raddr_bin ^ (raddr_bin >> 1);
    end
end

// Read pointer synchronizer
reg [ADDR_WIDTH-1:0] rptr_syn_temp1;
reg [ADDR_WIDTH-1:0] rptr_syn_temp2;
always @(posedge wclk) begin
    rptr_syn_temp1 <= rptr_gray;
    rptr_syn_temp2 <= rptr_syn_temp1;
end
assign rptr_syn = rptr_syn_temp2;

// Write pointer synchronizer
reg [ADDR_WIDTH-1:0] wptr_syn_temp1;
reg [ADDR_WIDTH-1:0] wptr_syn_temp2;
always @(posedge rclk) begin
    wptr_syn_temp1 <= wptr_gray;
    wptr_syn_temp2 <= wptr_syn_temp1;
end
assign wptr_syn = wptr_syn_temp2;

// Full and empty signal generation
always @(posedge wclk) begin
    if (~wrstn) begin
        wfull <= 0;
    end else if (winc && (wptr_gray[ADDR_WIDTH-1]!= rptr_syn[ADDR_WIDTH-1]) && (wptr_gray[ADDR_WIDTH-2:0] == rptr_syn[ADDR_WIDTH-2:0])) begin
        wfull <= 1;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        rempty <= 1;
    end else if (rinc && (rptr_gray == wptr_syn)) begin
        rempty <= 1;
    end else if (rinc && ~rempty) begin
        rempty <= 0;
    end
end

// Clock gating for power reduction
reg wclk_gate;
assign wclk_gate = winc && ~wfull;

endmodule
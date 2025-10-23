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

// Dual-port RAM module
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

// Instantiation of dual-port RAM module
dual_port_RAM #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
) RAM_inst (
    .wclk(wclk),
    .wenc(wen),
    .waddr(waddr_bin),
    .wdata(wdata),
    .rclk(rclk),
    .renc(ren),
    .raddr(raddr_bin),
    .rdata(rdata)
);

// Write and read pointers
reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] raddr_bin;

always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        raddr_bin <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

// Gray code conversion
reg [$clog2(DEPTH)-1:0] wptr;
reg [$clog2(DEPTH)-1:0] rptr;

always @(posedge wclk) begin
    wptr <= waddr_bin ^ (waddr_bin >> 1);
end

always @(posedge rclk) begin
    rptr <= raddr_bin ^ (raddr_bin >> 1);
end

// Read pointer synchronizer
reg [$clog2(DEPTH)-1:0] rptr_syn;
reg [$clog2(DEPTH)-1:0] rptr_syn_tmp;

always @(posedge wclk) begin
    rptr_syn_tmp <= rptr;
end

always @(posedge wclk) begin
    rptr_syn <= rptr_syn_tmp;
end

// Write pointer synchronizer
reg [$clog2(DEPTH)-1:0] wptr_syn;
reg [$clog2(DEPTH)-1:0] wptr_syn_tmp;

always @(posedge rclk) begin
    wptr_syn_tmp <= wptr;
end

always @(posedge rclk) begin
    wptr_syn <= wptr_syn_tmp;
end

// Full and empty signals
always @(posedge wclk) begin
    if (wptr == {~rptr_syn[$clog2(DEPTH)-1], rptr_syn[$clog2(DEPTH)-2:0]}) begin
        wfull <= 1'b1;
    end else begin
        wfull <= 1'b0;
    end
end

always @(posedge rclk) begin
    if (rptr == wptr_syn) begin
        rempty <= 1'b1;
    end else begin
        rempty <= 1'b0;
    end
end

// Input and output connections
reg wen;
reg ren;

always @(posedge wclk) begin
    if (winc && ~wfull) begin
        wen <= 1'b1;
    end else begin
        wen <= 1'b0;
    end
end

always @(posedge rclk) begin
    if (rinc && ~rempty) begin
        ren <= 1'b1;
    end else begin
        ren <= 1'b0;
    end
end

endmodule
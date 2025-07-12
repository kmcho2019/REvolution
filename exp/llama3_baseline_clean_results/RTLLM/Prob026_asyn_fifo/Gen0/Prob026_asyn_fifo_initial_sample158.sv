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

// Instantiate the dual-port RAM module
dual_port_RAM #(.WIDTH(WIDTH), .DEPTH(DEPTH)) ram_inst (
    .wclk(wclk),
    .wenc(wenc),
    .waddr(waddr),
    .wdata(wdata),
    .rclk(rclk),
    .renc(renc),
    .raddr(raddr),
    .rdata(rdata)
);

// Write pointer register
reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] waddr_bin_buff;

// Read pointer register
reg [$clog2(DEPTH)-1:0] raddr_bin;
reg [$clog2(DEPTH)-1:0] raddr_bin_buff;

// Gray code conversion
reg [$clog2(DEPTH)-1:0] wptr;
reg [$clog2(DEPTH)-1:0] rptr;
reg [$clog2(DEPTH)-1:0] wptr_syn;
reg [$clog2(DEPTH)-1:0] rptr_syn;

// Write and read enable signals
reg wenc;
reg renc;

// Full and empty signals
reg wfull;
reg rempty;

// Write controller
always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

// Read controller
always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
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

// Two-stage synchronizer for read pointer
always @(posedge wclk) begin
    wptr_syn <= rptr_syn;
    rptr_syn <= rptr;
end

// Two-stage synchronizer for write pointer
always @(posedge rclk) begin
    rptr_syn <= wptr_syn;
    wptr_syn <= wptr;
end

// Full and empty conditions
always @(*) begin
    if (wptr == {~rptr_syn[$clog2(DEPTH)-1], rptr_syn[$clog2(DEPTH)-2:0]}) begin
        wfull = 1'b1;
    end else begin
        wfull = 1'b0;
    end

    if (rptr_syn == wptr) begin
        rempty = 1'b1;
    end else begin
        rempty = 1'b0;
    end
end

// Write and read enable signals
assign wenc = winc & ~wfull;
assign renc = rinc & ~rempty;

// Address signals
assign waddr = waddr_bin[2:0];
assign raddr = raddr_bin[2:0];

endmodule
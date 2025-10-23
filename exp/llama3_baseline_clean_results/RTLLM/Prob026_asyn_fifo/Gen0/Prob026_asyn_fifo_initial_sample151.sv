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

reg [WIDTH-1:0] ram_rdata;
reg [WIDTH-1:0] wdata_reg;

reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] raddr_bin;

reg [$clog2(DEPTH)-1:0] wptr_buff;
reg [$clog2(DEPTH)-1:0] rptr_buff;

reg [$clog2(DEPTH)-1:0] wptr;
reg [$clog2(DEPTH)-1:0] rptr_syn;

reg wen;
reg ren;

always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

// Gray code conversion for write pointer
always @(posedge wclk) begin
    wptr_buff <= waddr_bin;
end

assign wptr = wptr_buff ^ (wptr_buff >> 1);

// Gray code conversion for read pointer
always @(posedge rclk) begin
    rptr_buff <= raddr_bin;
end

assign rptr_syn = rptr_buff ^ (rptr_buff >> 1);

// Dual-port RAM instantiation
dual_port_RAM #(
   .WIDTH(WIDTH),
   .DEPTH(DEPTH)
) dual_port_RAM_inst (
   .wclk(wclk),
   .wenc(wen),
   .waddr(waddr_bin[$clog2(DEPTH)-2:0]),
   .wdata(wdata_reg),
   .rclk(rclk),
   .renc(ren),
   .raddr(raddr_bin[$clog2(DEPTH)-2:0]),
   .rdata(ram_rdata)
);

// Write enable and read enable control
always @(posedge wclk) begin
    if (~wrstn) begin
        wdata_reg <= 0;
        wen <= 0;
    end else if (winc) begin
        wdata_reg <= wdata;
        wen <= 1;
    end else begin
        wen <= 0;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        ren <= 0;
    end else if (rinc) begin
        ren <= 1;
    end else begin
        ren <= 0;
    end
end

// Full and empty signal generation
always @(posedge wclk) begin
    if (wptr == ({~rptr_syn[$clog2(DEPTH)-1], rptr_syn[$clog2(DEPTH)-2:0]})) begin
        wfull <= 1;
    end else begin
        wfull <= 0;
    end
end

always @(posedge rclk) begin
    if (rptr_syn == wptr) begin
        rempty <= 1;
    end else begin
        rempty <= 0;
    end
end

// Output assignment
always @(posedge rclk) begin
    rdata <= ram_rdata;
end

endmodule

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
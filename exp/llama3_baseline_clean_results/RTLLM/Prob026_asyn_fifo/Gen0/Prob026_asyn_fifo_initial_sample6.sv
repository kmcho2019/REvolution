// Define the dual-port RAM module
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

reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

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

// Define the asynchronous FIFO module
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

parameter DEPTH = 16;
parameter WIDTH = 8;

reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

// Instantiating dual-port RAM module
dual_port_RAM dual_port_ram_inst(
    .wclk(wclk),
    .wenc(wen),
    .waddr(waddr),
    .wdata(wdata),
    .rclk(rclk),
    .renc(ren),
    .raddr(raddr),
    .rdata(rdata)
);

// Write pointer
reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] wptr;
reg [$clog2(DEPTH)-1:0] wptr_buff;

// Read pointer
reg [$clog2(DEPTH)-1:0] raddr_bin;
reg [$clog2(DEPTH)-1:0] rptr;
reg [$clog2(DEPTH)-1:0] rptr_buff;
reg [$clog2(DEPTH)-1:0] rptr_syn;

// Write enable signal
reg wen;

// Read enable signal
reg ren;

// Write pointer increment logic
always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

// Read pointer increment logic
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

// Write pointer buffer
always @(posedge wclk) begin
    wptr_buff <= wptr;
end

// Read pointer buffer
always @(posedge rclk) begin
    rptr_buff <= rptr;
end

// Read pointer synchronizer
always @(posedge wclk) begin
    rptr_syn <= rptr_buff;
end

// Write enable logic
always @(posedge wclk) begin
    wen <= winc;
end

// Read enable logic
always @(posedge rclk) begin
    ren <= rinc;
end

// Full judgment logic
always @(posedge wclk) begin
    if (wptr == ({~rptr_syn[$clog2(DEPTH)-1], rptr_syn[$clog2(DEPTH)-2:0]})) begin
        wfull <= 1;
    end else begin
        wfull <= 0;
    end
end

// Empty judgment logic
always @(posedge rclk) begin
    if (rptr == wptr_buff) begin
        rempty <= 1;
    end else begin
        rempty <= 0;
    end
end

// Write address logic
assign waddr = waddr_bin[$clog2(DEPTH)-1:1];

// Read address logic
assign raddr = raddr_bin[$clog2(DEPTH)-1:1];

endmodule
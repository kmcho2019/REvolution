module asyn_fifo #
(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)
(
    input             wclk,
    input             rclk,
    input             wrstn,
    input             rrstn,
    input             winc,
    input             rinc,
    input   [WIDTH-1:0] wdata,
    output reg        wfull,
    output reg        rempty,
    output reg [WIDTH-1:0] rdata
);

// Instantiate dual-port RAM module
dual_port_RAM #(.DEPTH(DEPTH), .WIDTH(WIDTH)) ram_instance (
    .wclk(wclk),
    .rclk(rclk),
    .wenc(wen),
    .waddr(waddr_bin),
    .wdata(wdata),
    .renc(ren),
    .raddr(raddr_bin),
    .rdata(rdata_ram)
);

// Internal signals
reg [WIDTH-1:0] rdata_ram;
reg             wen;
reg             ren;
reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] raddr_bin;
reg [$clog2(DEPTH)-1:0] wptr;
reg [$clog2(DEPTH)-1:0] rptr;
reg [$clog2(DEPTH)-1:0] wptr_buff;
reg [$clog2(DEPTH)-1:0] rptr_buff;
reg [$clog2(DEPTH)-1:0] rptr_syn;

// Write pointer logic
always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        waddr_bin <= 0;
        wptr_buff <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
        wptr_buff <= waddr_bin;
    end
end

// Read pointer logic
always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        raddr_bin <= 0;
        rptr_buff <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
        rptr_buff <= raddr_bin;
    end
end

// Gray code conversion for write pointer
always @(*) begin
    wptr = waddr_bin ^ (waddr_bin >> 1);
end

// Gray code conversion for read pointer
always @(*) begin
    rptr = raddr_bin ^ (raddr_bin >> 1);
end

// Synchronize read pointer to write clock domain
always @(posedge wclk) begin
    rptr_syn <= rptr_buff;
end

// Full and empty signal generation
always @(*) begin
    if (wptr == (~rptr_syn[$clog2(DEPTH)-1:1] & rptr_syn[0])) begin
        wfull = 1'b1;
    end else begin
        wfull = 1'b0;
    end
    
    if (rptr == wptr) begin
        rempty = 1'b1;
    end else begin
        rempty = 1'b0;
    end
end

// Write enable signal generation
always @(*) begin
    if (~wfull) begin
        wen = winc;
    end else begin
        wen = 1'b0;
    end
end

// Read enable signal generation
always @(*) begin
    if (~rempty) begin
        ren = rinc;
    end else begin
        ren = 1'b0;
    end
end

endmodule

module dual_port_RAM #
(
    parameter DEPTH = 16,
    parameter WIDTH = 8
)
(
    input             wclk,
    input             rclk,
    input             wenc,
    input   [$clog2(DEPTH)-1:0] waddr,
    input   [WIDTH-1:0] wdata,
    input             renc,
    input   [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);

// Internal signals
reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

// Write logic
always @(posedge wclk) begin
    if (wenc) begin
        RAM_MEM[waddr] <= wdata;
    end
end

// Read logic
always @(posedge rclk) begin
    if (renc) begin
        rdata <= RAM_MEM[raddr];
    end
end

endmodule
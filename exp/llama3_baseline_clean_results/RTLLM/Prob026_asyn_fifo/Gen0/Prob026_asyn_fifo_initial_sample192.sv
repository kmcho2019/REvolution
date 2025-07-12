module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input  logic               wclk,
    input  logic               rclk,
    input  logic               wrstn,
    input  logic               rrstn,
    input  logic               winc,
    input  logic               rinc,
    input  logic [WIDTH-1:0]   wdata,
    output logic               wfull,
    output logic               rempty,
    output logic [WIDTH-1:0]   rdata
);

// Instantiation of dual-port RAM
dual_port_RAM #(
   .WIDTH(WIDTH),
   .DEPTH(DEPTH)
) u_dual_port_RAM (
   .wclk(wclk),
   .wenc(wen),
   .waddr(waddr_bin),
   .wdata(wdata),
   .rclk(rclk),
   .renc(ren),
   .raddr(raddr_bin),
   .rdata(rdata)
);

// Write pointer logic
logic [WIDTH-1:0] waddr_bin;
logic [WIDTH-1:0] wptr;
logic [WIDTH-1:0] wptr_buff;

always_ff @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        waddr_bin <= 0;
        wptr_buff <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
        wptr_buff <= wptr;
    end
end

always_comb begin
    wptr = waddr_bin[WIDTH-1:1] ^ (waddr_bin[WIDTH-1:1] >> 1);
end

// Read pointer logic
logic [WIDTH-1:0] raddr_bin;
logic [WIDTH-1:0] rptr;
logic [WIDTH-1:0] rptr_syn;
logic [WIDTH-1:0] rptr_buff;

always_ff @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        raddr_bin <= 0;
        rptr_buff <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
        rptr_buff <= rptr;
    end
end

always_comb begin
    rptr = raddr_bin[WIDTH-1:1] ^ (raddr_bin[WIDTH-1:1] >> 1);
    rptr_syn = rptr_buff;
end

// Write and read enable signals
logic wen;
logic ren;

always_comb begin
    wen = winc & ~wfull;
    ren = rinc & ~rempty;
end

// Full and empty signals
always_comb begin
    wfull = (wptr == {~rptr_syn[WIDTH-1], rptr_syn[WIDTH-2:0]});
    rempty = (rptr_syn == wptr);
end

endmodule

// Dual-port RAM module
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input  logic               wclk,
    input  logic               wenc,
    input  logic [$clog2(DEPTH)-1:0] waddr,
    input  logic [WIDTH-1:0]   wdata,
    input  logic               rclk,
    input  logic               renc,
    input  logic [$clog2(DEPTH)-1:0] raddr,
    output logic [WIDTH-1:0]   rdata
);

// RAM memory
logic [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

// Write logic
always_ff @(posedge wclk) begin
    if (wenc) begin
        RAM_MEM[waddr] <= wdata;
    end
end

// Read logic
always_ff @(posedge rclk) begin
    if (renc) begin
        rdata <= RAM_MEM[raddr];
    end
end

endmodule
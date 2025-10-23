module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)
(
    input               wclk,
    input               rclk,
    input               wrstn,
    input               rrstn,
    input               winc,
    input               rinc,
    input   [WIDTH-1:0] wdata,
    output              wfull,
    output              rempty,
    output  [WIDTH-1:0] rdata
);

// Define the dual-port RAM module
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)
(
    input               wclk,
    input               wenc,
    input   [$clog2(DEPTH)-1:0] waddr,
    input   [WIDTH-1:0] wdata,
    input               rclk,
    input               renc,
    input   [$clog2(DEPTH)-1:0] raddr,
    output  [WIDTH-1:0] rdata
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
dual_port_RAM #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
) ram_inst (
    .wclk(wclk),
    .wenc(winc),
    .waddr(waddr),
    .wdata(wdata),
    .rclk(rclk),
    .renc(rinc),
    .raddr(raddr),
    .rdata(rdata)
);

// Define the write and read pointer registers
reg [$clog2(DEPTH)-1:0] waddr;
reg [$clog2(DEPTH)-1:0] raddr;
reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] raddr_bin;

// Define the Gray code conversion
reg [$clog2(DEPTH)-1:0] wptr;
reg [$clog2(DEPTH)-1:0] rptr;

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

// Define the buffer registers
reg [$clog2(DEPTH)-1:0] wptr_buff;
reg [$clog2(DEPTH)-1:0] rptr_buff;

always @(posedge wclk) begin
    wptr_buff <= wptr;
end

always @(posedge rclk) begin
    rptr_buff <= rptr;
end

// Define the Gray code conversion
always @(posedge wclk) begin
    wptr <= (waddr_bin >> 1) ^ waddr_bin;
end

always @(posedge rclk) begin
    rptr <= (raddr_bin >> 1) ^ raddr_bin;
end

// Define the full and empty signals
wire wfull_int;
wire rempty_int;

assign wfull_int = (wptr == (~rptr[$clog2(DEPTH)-1:1] ^ rptr[0]);
assign rempty_int = (wptr == rptr);

// Define the output signals
assign wfull = wfull_int;
assign rempty = rempty_int;

// Define the read and write addresses
assign waddr = waddr_bin[$clog2(DEPTH)-2:0];
assign raddr = raddr_bin[$clog2(DEPTH)-2:0];

endmodule
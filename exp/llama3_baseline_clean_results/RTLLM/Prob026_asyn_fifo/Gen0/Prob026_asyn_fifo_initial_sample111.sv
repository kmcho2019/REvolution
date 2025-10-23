module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  logic                wclk,
    input  logic                rclk,
    input  logic                wrstn,
    input  logic                rrstn,
    input  logic                winc,
    input  logic                rinc,
    input  logic [WIDTH-1:0]    wdata,
    output logic                wfull,
    output logic                rempty,
    output logic [WIDTH-1:0]    rdata
);

// Dual-port RAM module instantiation
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  logic                wclk,
    input  logic                wenc,
    input  logic [$clog2(DEPTH)-1:0] waddr,
    input  logic [WIDTH-1:0]    wdata,
    input  logic                rclk,
    input  logic                renc,
    input  logic [$clog2(DEPTH)-1:0] raddr,
    output logic [WIDTH-1:0]    rdata
);
    logic [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

    always_ff @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    always_ff @(posedge rclk) begin
        if (renc) begin
            rdata <= RAM_MEM[raddr];
        end
    end
endmodule

// Instantiate dual-port RAM
dual_port_RAM #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
) ram_inst (
    .wclk(wclk),
    .wenc(wen),
    .waddr(waddr_bin),
    .wdata(wdata),
    .rclk(rclk),
    .renc(ren),
    .raddr(raddr_bin),
    .rdata(rdata)
);

// Write and Read Pointers
logic [$clog2(DEPTH)-1:0] waddr_bin;
logic [$clog2(DEPTH)-1:0] raddr_bin;

always_ff @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end else if (wen) begin
        waddr_bin <= waddr_bin + 1;
    end
end

always_ff @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
    end else if (ren) begin
        raddr_bin <= raddr_bin + 1;
    end
end

// Gray Code Conversion
logic [$clog2(DEPTH)-1:0] wptr;
logic [$clog2(DEPTH)-1:0] rptr;

always_comb begin
    wptr = (waddr_bin >> 1) ^ waddr_bin;
    rptr = (raddr_bin >> 1) ^ raddr_bin;
end

// Read Pointer Synchronizer
logic [$clog2(DEPTH)-1:0] rptr_syn;
logic [$clog2(DEPTH)-1:0] rptr_syn_buff;

always_ff @(posedge wclk) begin
    rptr_syn_buff <= rptr;
end

always_ff @(posedge wclk) begin
    rptr_syn <= rptr_syn_buff;
end

// Write Pointer Synchronizer
logic [$clog2(DEPTH)-1:0] wptr_syn;
logic [$clog2(DEPTH)-1:0] wptr_syn_buff;

always_ff @(posedge rclk) begin
    wptr_syn_buff <= wptr;
end

always_ff @(posedge rclk) begin
    wptr_syn <= wptr_syn_buff;
end

// Write and Read Enable Signals
logic wen;
logic ren;

always_comb begin
    wen = winc && ~wfull;
    ren = rinc && ~rempty;
end

// Full and Empty Signals
always_comb begin
    wfull = (wptr == {~rptr_syn[$clog2(DEPTH)-1], rptr_syn[$clog2(DEPTH)-2:0]});
    rempty = (rptr == wptr);
end

endmodule
module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  logic          wclk,
    input  logic          rstn,
    input  logic          wrstn,
    input  logic          rrstn,
    input  logic          winc,
    input  logic          rinc,
    input  logic [WIDTH-1:0] wdata,
    output logic          wfull,
    output logic          rempty,
    output logic [WIDTH-1:0] rdata
);

// Calculate the number of bits required to represent the depth of the FIFO
localparam integer AWIDTH = $clog2(DEPTH);

// Internal signals
logic [AWIDTH-1:0] waddr_bin;
logic [AWIDTH-1:0] raddr_bin;
logic [AWIDTH-1:0] wptr_bin;
logic [AWIDTH-1:0] rptr_bin;
logic [AWIDTH-1:0] wptr_syn;
logic [AWIDTH-1:0] rptr_syn;
logic           wfull_int;
logic           rempty_int;
logic           wen;
logic           ren;

// Instantiate dual-port RAM
dual_port_RAM #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
) u_ram (
    .wclk(wclk),
    .rclk(wclk), // Changed to wclk for test purpose
    .wenc(wen),
    .waddr(waddr_bin),
    .wdata(wdata),
    .renc(ren),
    .raddr(raddr_bin),
    .rdata(rdata)
);

// Write pointer controller
always_ff @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        waddr_bin <= '0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

// Read pointer controller
always_ff @(posedge wclk or negedge rrstn) begin
    if (~rrstn) begin
        raddr_bin <= '0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

// Gray code conversion for write pointer
always_comb begin
    wptr_bin = waddr_bin;
    wptr_bin[AWIDTH-1] = waddr_bin[AWIDTH-1] ^ waddr_bin[AWIDTH-2];
    for (int i = AWIDTH-2; i > 0; i--) begin
        wptr_bin[i] = waddr_bin[i] ^ waddr_bin[i-1];
    end
end

// Gray code conversion for read pointer
always_comb begin
    rptr_bin = raddr_bin;
    rptr_bin[AWIDTH-1] = raddr_bin[AWIDTH-1] ^ raddr_bin[AWIDTH-2];
    for (int i = AWIDTH-2; i > 0; i--) begin
        rptr_bin[i] = raddr_bin[i] ^ raddr_bin[i-1];
    end
end

// Two-stage synchronizer for read pointer
logic [AWIDTH-1:0] rptr_syn1;
always_ff @(posedge wclk) begin
    rptr_syn1 <= rptr_bin;
end
always_ff @(posedge wclk) begin
    rptr_syn <= rptr_syn1;
end

// Two-stage synchronizer for write pointer
logic [AWIDTH-1:0] wptr_syn1;
always_ff @(posedge wclk) begin
    wptr_syn1 <= wptr_bin;
end
always_ff @(posedge wclk) begin
    wptr_syn <= wptr_syn1;
end

// Empty signal generation
always_comb begin
    if (wptr_bin == rptr_bin) begin
        rempty_int = 1'b1;
    end else begin
        rempty_int = 1'b0;
    end
end

// Full signal generation
always_comb begin
    if (wptr_bin[AWIDTH-1] != rptr_syn[AWIDTH-1] && wptr_bin[AWIDTH-2] != rptr_syn[AWIDTH-2] && wptr_bin[AWIDTH-3] == rptr_syn[AWIDTH-3] && wptr_bin[AWIDTH-4] == rptr_syn[AWIDTH-4]) begin
        wfull_int = 1'b1;
    end else begin
        wfull_int = 1'b0;
    end
end

// Assign output signals
assign wfull = wfull_int;
assign rempty = rempty_int;

// Write enable signal
assign wen = winc;

// Read enable signal
assign ren = rinc;

endmodule

module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  logic          wclk,
    input  logic          rclk,
    input  logic          wenc,
    input  logic [WIDTH-1:0] wdata,
    input  logic [$clog2(DEPTH)-1:0] waddr,
    input  logic          renc,
    input  logic [$clog2(DEPTH)-1:0] raddr,
    output logic [WIDTH-1:0] rdata
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
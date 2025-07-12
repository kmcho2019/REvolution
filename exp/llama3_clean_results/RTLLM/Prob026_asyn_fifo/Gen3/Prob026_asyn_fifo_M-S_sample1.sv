module asyn_fifo #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
)(
    input  logic            wclk,
    input  logic            rclk,
    input  logic            wrstn,
    input  logic            rrstn,
    input  logic            winc,
    input  logic            rinc,
    input  logic [WIDTH-1:0] wdata,
    output logic            wfull,
    output logic            rempty,
    output logic [WIDTH-1:0] rdata
);

// Dual-port RAM module
module dual_port_RAM #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
)(
    input  logic            wclk,
    input  logic            wenc,
    input  logic [$clog2(DEPTH)-1:0] waddr,
    input  logic [WIDTH-1:0] wdata,
    input  logic            rclk,
    input  logic            renc,
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

// Instantiate dual-port RAM module
dual_port_RAM #(
 .DEPTH(DEPTH),
 .WIDTH(WIDTH)
) dual_port_RAM_inst (
 .wclk(wclk),
 .wenc(winc),
 .waddr(wptr_bin[$clog2(DEPTH)-1:0]),
 .wdata(wdata),
 .rclk(rclk),
 .renc(rinc),
 .raddr(rptr_bin[$clog2(DEPTH)-1:0]),
 .rdata(rdata)
);

// Write and read pointer management
logic [$clog2(DEPTH)-1:0] wptr_bin;
logic [$clog2(DEPTH)-1:0] rptr_bin;
logic [$clog2(DEPTH)-1:0] wptr_syn;
logic [$clog2(DEPTH)-1:0] rptr_syn;

always_ff @(posedge wclk) begin
    if (~wrstn) begin
        wptr_bin <= 0;
    end else if (winc) begin
        wptr_bin <= wptr_bin + 1;
    end
end

always_ff @(posedge rclk) begin
    if (~rrstn) begin
        rptr_bin <= 0;
    end else if (rinc) begin
        rptr_bin <= rptr_bin + 1;
    end
end

// Two-stage synchronizer for write and read pointers
logic [$clog2(DEPTH)-1:0] wptr_reg1;
logic [$clog2(DEPTH)-1:0] rptr_reg1;

always_ff @(posedge rclk) begin
    wptr_reg1 <= wptr_bin;
end

always_ff @(posedge wclk) begin
    rptr_reg1 <= rptr_bin;
end

always_ff @(posedge rclk) begin
    wptr_syn <= wptr_reg1;
end

always_ff @(posedge wclk) begin
    rptr_syn <= rptr_reg1;
end

// Counters for full and empty signals
logic [$clog2(DEPTH):0] wcount;
logic [$clog2(DEPTH):0] rcount;

always_ff @(posedge wclk) begin
    if (~wrstn) begin
        wcount <= 0;
    end else if (winc) begin
        wcount <= wcount + 1;
    end
end

always_ff @(posedge rclk) begin
    if (~rrstn) begin
        rcount <= 0;
    end else if (rinc) begin
        rcount <= rcount - 1;
    end
end

// Full and empty signals
assign wfull = (wcount == DEPTH);
assign rempty = (rcount == 0);

endmodule
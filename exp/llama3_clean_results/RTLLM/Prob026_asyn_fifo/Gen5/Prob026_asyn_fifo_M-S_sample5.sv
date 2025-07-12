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
 .wenc(wen),
 .waddr(wptr_bin),
 .wdata(wdata),
 .rclk(rclk),
 .renc(ren),
 .raddr(rptr_bin),
 .rdata(rdata)
);

// Write and read pointer management
logic [$clog2(DEPTH)-1:0] wptr_bin;
logic [$clog2(DEPTH)-1:0] rptr_bin;
logic [$clog2(DEPTH)-1:0] wptr_gray;
logic [$clog2(DEPTH)-1:0] rptr_gray;

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

// Gray code conversion
always_ff @(posedge wclk) begin
    wptr_gray <= wptr_bin ^ (wptr_bin >> 1);
end

always_ff @(posedge rclk) begin
    rptr_gray <= rptr_bin ^ (rptr_bin >> 1);
end

// Two-stage synchronizer for write and read pointers
logic [$clog2(DEPTH)-1:0] wptr_reg1;
logic [$clog2(DEPTH)-1:0] rptr_reg1;

always_ff @(posedge rclk) begin
    wptr_reg1 <= wptr_gray;
end

always_ff @(posedge wclk) begin
    rptr_reg1 <= rptr_gray;
end

// Full and empty signals
assign wfull = (wptr_gray == {~rptr_gray[$clog2(DEPTH)-1], rptr_gray[$clog2(DEPTH)-2:0]});
assign rempty = (rptr_gray == wptr_gray);

// Write and read enable signals
logic wen;
logic ren;

always_ff @(posedge wclk) begin
    if (~wrstn) begin
        wen <= 0;
    end else if (winc) begin
        wen <= 1;
    end
end

always_ff @(posedge rclk) begin
    if (~rrstn) begin
        ren <= 0;
    end else if (rinc) begin
        ren <= 1;
    end
end

endmodule
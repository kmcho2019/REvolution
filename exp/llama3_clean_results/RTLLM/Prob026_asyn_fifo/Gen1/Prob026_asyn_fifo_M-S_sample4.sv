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
   .waddr(wptr[$clog2(DEPTH)-2:0]),
   .wdata(wdata),
   .rclk(rclk),
   .renc(rinc),
   .raddr(rptr[$clog2(DEPTH)-2:0]),
   .rdata(rdata)
);

// Write and read pointer management
logic [$clog2(DEPTH)-1:0] wptr;
logic [$clog2(DEPTH)-1:0] rptr;

always_ff @(posedge wclk) begin
    if (~wrstn) begin
        wptr <= 0;
    end else if (winc) begin
        wptr <= wptr + 1;
    end
end

always_ff @(posedge rclk) begin
    if (~rrstn) begin
        rptr <= 0;
    end else if (rinc) begin
        rptr <= rptr + 1;
    end
end

// Synchronize write pointer to read clock domain
logic [$clog2(DEPTH)-1:0] wptr_syn;

always_ff @(posedge rclk) begin
    wptr_syn <= wptr;
end

// Full and empty signals
assign wfull = (wptr == {~rptr[$clog2(DEPTH)-1], rptr[$clog2(DEPTH)-2:0]});
assign rempty = (rptr == wptr);

endmodule
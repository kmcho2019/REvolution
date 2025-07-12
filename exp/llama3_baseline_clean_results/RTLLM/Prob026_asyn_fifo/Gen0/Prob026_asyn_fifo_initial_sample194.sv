// Dual-port RAM module
module dual_port_RAM #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
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

// Asynchronous FIFO module
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
    output wfull,
    output rempty,
    output [WIDTH-1:0] rdata
);
    // Dual-port RAM instantiation
    dual_port_RAM #(.DEPTH(DEPTH), .WIDTH(WIDTH)) RAM (
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr_bin[$clog2(DEPTH)-1:0]),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr_bin[$clog2(DEPTH)-1:0]),
        .rdata(rdata_out)
    );

    // Write pointer logic
    reg [$clog2(DEPTH)-1:0] waddr_bin;
    reg [2:0] wptr;
    reg [2:0] wptr_buff;

    always @(posedge wclk) begin
        if (~wrstn) begin
            waddr_bin <= 0;
            wptr <= 0;
            wptr_buff <= 0;
        end else if (winc) begin
            waddr_bin <= waddr_bin + 1;
            wptr <= {waddr_bin[2] ^ waddr_bin[1], waddr_bin[1] ^ waddr_bin[0], waddr_bin[0]};
            wptr_buff <= wptr;
        end
    end

    // Read pointer logic
    reg [$clog2(DEPTH)-1:0] raddr_bin;
    reg [2:0] rptr;
    reg [2:0] rptr_buff;
    reg [2:0] rptr_syn;

    always @(posedge rclk) begin
        if (~rrstn) begin
            raddr_bin <= 0;
            rptr <= 0;
            rptr_buff <= 0;
            rptr_syn <= 0;
        end else if (rinc) begin
            raddr_bin <= raddr_bin + 1;
            rptr <= {raddr_bin[2] ^ raddr_bin[1], raddr_bin[1] ^ raddr_bin[0], raddr_bin[0]};
            rptr_buff <= rptr;
        end
        rptr_syn <= wptr_buff;
    end

    // Full and empty signal logic
    assign wfull = (wptr == {~rptr_syn[2], rptr_syn[1:0]});
    assign rempty = (rptr == wptr);

    // Input and output connections
    assign wen = winc;
    assign ren = rinc;
    assign rdata = rdata_out;
endmodule
// dual_port_RAM module
module dual_port_RAM #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
) (
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

// asyn_fifo module
module asyn_fifo #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
) (
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
    reg [$clog2(DEPTH)-1:0] waddr_bin;
    reg [$clog2(DEPTH)-1:0] raddr_bin;
    reg [$clog2(DEPTH)-1:0] wptr;
    reg [$clog2(DEPTH)-1:0] rptr;
    reg [$clog2(DEPTH)-1:0] wptr_buff;
    reg [$clog2(DEPTH)-1:0] rptr_buff;
    reg [WIDTH-1:0] wenc;
    reg [WIDTH-1:0] renc;
    wire wfull_wire;
    wire rempty_wire;

    // write controller
    always @(posedge wclk) begin
        if (~wrstn) begin
            waddr_bin <= 0;
        end else if (winc) begin
            waddr_bin <= waddr_bin + 1;
        end
    end

    // read controller
    always @(posedge rclk) begin
        if (~rrstn) begin
            raddr_bin <= 0;
        end else if (rinc) begin
            raddr_bin <= raddr_bin + 1;
        end
    end

    // Gray code conversion for write pointer
    assign wptr = (waddr_bin >> 1) ^ waddr_bin;

    // Gray code conversion for read pointer
    assign rptr = (raddr_bin >> 1) ^ raddr_bin;

    // read pointer synchronizer
    always @(posedge wclk) begin
        rptr_buff <= rptr;
    end

    // write pointer synchronizer
    always @(posedge rclk) begin
        wptr_buff <= wptr;
    end

    // full and empty signals
    assign wfull_wire = (wptr == ({~rptr_buff[$clog2(DEPTH)-1], rptr_buff[$clog2(DEPTH)-2:0]}));
    assign rempty_wire = (rptr == wptr);

    // output assignments
    assign wfull = wfull_wire;
    assign rempty = rempty_wire;

    // instantiate dual-port RAM module
    dual_port_RAM #(.DEPTH(DEPTH), .WIDTH(WIDTH)) ram (
        .wclk(wclk),
        .wenc(winc),
        .waddr(waddr_bin[$clog2(DEPTH)-2:0]),
        .wdata(wdata),
        .rclk(rclk),
        .renc(rinc),
        .raddr(raddr_bin[$clog2(DEPTH)-2:0]),
        .rdata(rdata)
    );
endmodule
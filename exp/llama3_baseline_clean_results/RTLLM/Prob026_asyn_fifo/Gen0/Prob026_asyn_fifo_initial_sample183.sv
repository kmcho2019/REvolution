module dual_port_RAM(
    input           wclk,
    input           wenc,
    input   [$clog2(DEPTH)-1:0] waddr,
    input   [WIDTH-1:0] wdata,
    input           rclk,
    input           renc,
    input   [$clog2(DEPTH)-1:0] raddr,
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

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input           wclk,
    input           wrstn,
    input           rclk,
    input           rrstn,
    input           winc,
    input           rinc,
    input   [WIDTH-1:0] wdata,
    output          wfull,
    output          rempty,
    output  [WIDTH-1:0] rdata
);

    reg [$clog2(DEPTH)-1:0] waddr_bin;
    reg [$clog2(DEPTH)-1:0] raddr_bin;
    reg [WIDTH-1:0] wptr_bin;
    reg [WIDTH-1:0] rptr_bin;

    reg [$clog2(DEPTH)-1:0] wptr;
    reg [$clog2(DEPTH)-1:0] rptr_syn;
    reg [$clog2(DEPTH)-1:0] wptr_buff;
    reg [$clog2(DEPTH)-1:0] rptr_buff;

    wire            wen;
    wire            ren;

    dual_port_RAM #(.WIDTH(WIDTH), .DEPTH(DEPTH)) RAM_inst(
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr_bin),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr_bin),
        .rdata(rdata)
    );

    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            waddr_bin <= 0;
        end else if (winc) begin
            waddr_bin <= waddr_bin + 1;
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            raddr_bin <= 0;
        end else if (rinc) begin
            raddr_bin <= raddr_bin + 1;
        end
    end

    // Gray code conversion
    assign wptr = (waddr_bin >> 1) ^ waddr_bin;
    assign rptr_syn = (rptr_buff >> 1) ^ rptr_buff;

    always @(posedge rclk) begin
        rptr_buff <= wptr;
    end

    always @(posedge wclk) begin
        wptr_buff <= rptr_syn;
    end

    // Full and empty signals
    assign wfull = (wptr == {~rptr_syn[$clog2(DEPTH)-1], rptr_syn[$clog2(DEPTH)-2:0]});
    assign rempty = (rptr_syn == wptr);

    // Control signals
    assign wen = winc & ~wfull;
    assign ren = rinc & ~rempty;

endmodule
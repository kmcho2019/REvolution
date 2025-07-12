module dual_port_RAM(
    input wclk,
    input wenc,
    input [$clog2($bits(waddr))-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input renc,
    input [$clog2($bits(raddr))-1:0] raddr,
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

module asyn_fifo(
    input wclk,
    input rclk,
    input wrstn,
    input rrstn,
    input winc,
    input rinc,
    input [WIDTH-1:0] wdata,
    output reg wfull,
    output reg rempty,
    output reg [WIDTH-1:0] rdata
);

    parameter WIDTH = 8;
    parameter DEPTH = 16;

    reg [$clog2(DEPTH)-1:0] waddr_bin;
    reg [$clog2(DEPTH)-1:0] raddr_bin;

    reg [2:0] wptr;
    reg [2:0] rptr;
    reg [2:0] rptr_syn;

    reg [2:0] wptr_buff;
    reg [2:0] rptr_buff;

    wire wen;
    wire ren;

    dual_port_RAM RAM(
        .wclk(wclk),
        .wenc(wen),
        .waddr(waddr_bin),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(raddr_bin),
        .rdata(rdata)
    );

    assign wen = winc && ~wfull;
    assign ren = rinc && ~rempty;

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

    always @(posedge wclk) begin
        wptr_buff <= wptr;
    end

    always @(posedge rclk) begin
        rptr_buff <= rptr;
    end

    always @(posedge wclk) begin
        wptr <= {waddr_bin[2], waddr_bin[2] ^ waddr_bin[1], waddr_bin[1] ^ waddr_bin[0]};
    end

    always @(posedge rclk) begin
        rptr <= {raddr_bin[2], raddr_bin[2] ^ raddr_bin[1], raddr_bin[1] ^ raddr_bin[0]};
    end

    always @(posedge rclk) begin
        rptr_syn <= wptr_buff;
    end

    always @(posedge wclk) begin
        if (wptr == {~rptr_syn[2], rptr_syn[1], rptr_syn[0]}) begin
            wfull <= 1'b1;
        end else begin
            wfull <= 1'b0;
        end
    end

    always @(posedge rclk) begin
        if (rptr == wptr) begin
            rempty <= 1'b1;
        end else begin
            rempty <= 1'b0;
        end
    end

endmodule
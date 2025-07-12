// Dual-port RAM module
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

// Asynchronous FIFO module
module asyn_fifo(
    input           wclk,
    input           wrstn,
    input           winc,
    input   [WIDTH-1:0] wdata,
    input           rclk,
    input           rrstn,
    input           rinc,
    output          wfull,
    output          rempty,
    output  [WIDTH-1:0] rdata
);
    parameter WIDTH = 8;
    parameter DEPTH = 16;

    reg [$clog2(DEPTH)-1:0] waddr_bin;
    reg [$clog2(DEPTH)-1:0] raddr_bin;
    reg [WIDTH-1:0] wptr;
    reg [WIDTH-1:0] rptr;
    reg [WIDTH-1:0] wptr_buff;
    reg [WIDTH-1:0] rptr_buff;
    reg [WIDTH-1:0] rptr_syn;
    wire             wenc;
    wire             renc;
    wire             wfull_int;
    wire             rempty_int;

    dual_port_RAM RAM(
        .wclk(wclk),
        .wenc(wenc),
        .waddr(waddr_bin),
        .wdata(wdata),
        .rclk(rclk),
        .renc(renc),
        .raddr(raddr_bin),
        .rdata(rdata)
    );

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

    // Gray code conversion
    assign wptr = {waddr_bin[$clog2(DEPTH)-1], waddr_bin[$clog2(DEPTH)-1:1] ^ waddr_bin[$clog2(DEPTH)-2:0]};
    assign rptr = {raddr_bin[$clog2(DEPTH)-1], raddr_bin[$clog2(DEPTH)-1:1] ^ raddr_bin[$clog2(DEPTH)-2:0]};

    // Pointer buffers
    always @(posedge wclk) begin
        if (~wrstn) begin
            wptr_buff <= 0;
        end else begin
            wptr_buff <= wptr;
        end
    end

    always @(posedge rclk) begin
        if (~rrstn) begin
            rptr_buff <= 0;
        end else begin
            rptr_buff <= rptr;
        end
    end

    // Two-stage synchronizer for read pointer
    reg [WIDTH-1:0] rptr_sync1;
    reg [WIDTH-1:0] rptr_sync2;
    always @(posedge wclk) begin
        rptr_sync1 <= rptr_buff;
    end
    always @(posedge wclk) begin
        rptr_sync2 <= rptr_sync1;
    end
    assign rptr_syn = rptr_sync2;

    // Two-stage synchronizer for write pointer
    reg [WIDTH-1:0] wptr_sync1;
    reg [WIDTH-1:0] wptr_sync2;
    always @(posedge rclk) begin
        wptr_sync1 <= wptr_buff;
    end
    always @(posedge rclk) begin
        wptr_sync2 <= wptr_sync1;
    end

    // Full and empty signals
    assign wfull_int = (wptr_syn == {~rptr_buff[$clog2(DEPTH)-1], rptr_buff[$clog2(DEPTH)-1:1]});
    assign rempty_int = (rptr == wptr_syn);

    // Output signals
    assign wfull = wfull_int;
    assign rempty = rempty_int;

    // Control signals
    assign wenc = winc & ~wfull_int;
    assign renc = rinc & ~rempty_int;
endmodule
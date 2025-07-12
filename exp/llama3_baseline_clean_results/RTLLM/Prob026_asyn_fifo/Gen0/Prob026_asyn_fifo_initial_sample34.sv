module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  wclk,
    input  rstn,
    input  wrstn,
    input  rrstn,
    input  winc,
    input  rinc,
    input  [WIDTH-1:0] wdata,
    output wfull,
    output rempty,
    output [WIDTH-1:0] rdata
);

    // Parameters
    localparam ADDR_WIDTH = $clog2(DEPTH);

    // Signals
    reg [ADDR_WIDTH-1:0] waddr_bin;
    reg [ADDR_WIDTH-1:0] raddr_bin;
    reg [ADDR_WIDTH-1:0] waddr_bin_next;
    reg [ADDR_WIDTH-1:0] raddr_bin_next;
    reg [ADDR_WIDTH:0] wptr;
    reg [ADDR_WIDTH:0] rptr;
    reg [ADDR_WIDTH:0] wptr_buff;
    reg [ADDR_WIDTH:0] rptr_buff;
    reg [WIDTH-1:0] rdata_out;

    // Dual-port RAM
    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
        .wclk(wclk),
        .wenc(winc),
        .waddr(waddr_bin),
        .wdata(wdata),
        .rclk(rclk),
        .renc(rinc),
        .raddr(raddr_bin),
        .rdata(rdata_out)
    );

    // Gray code conversion
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
        wptr[ADDR_WIDTH-1:0] <= waddr_bin;
        wptr[ADDR_WIDTH] <= waddr_bin[ADDR_WIDTH-1] ^ waddr_bin[ADDR_WIDTH-2];
    end

    always @(posedge rclk) begin
        rptr[ADDR_WIDTH-1:0] <= raddr_bin;
        rptr[ADDR_WIDTH] <= raddr_bin[ADDR_WIDTH-1] ^ raddr_bin[ADDR_WIDTH-2];
    end

    // Pointer buffers
    always @(posedge wclk) begin
        if (~wrstn) begin
            wptr_buff <= 0;
        end else begin
            wptr_buff <= wptr;
        end
    end

    reg [ADDR_WIDTH:0] rptr_syn;

    always @(posedge rclk) begin
        if (~rrstn) begin
            rptr_syn <= 0;
        end else begin
            rptr_syn <= wptr_buff;
        end
    end

    always @(posedge rclk) begin
        if (~rrstn) begin
            rptr_buff <= 0;
        end else begin
            rptr_buff <= rptr;
        end
    end

    // Full and empty signals
    assign wfull = (wptr[ADDR_WIDTH] != rptr_syn[ADDR_WIDTH]) && (wptr[ADDR_WIDTH-1:0] == rptr_syn[ADDR_WIDTH-1:0]);

    assign rempty = (wptr[ADDR_WIDTH:0] == rptr[ADDR_WIDTH:0]);

    assign rdata = rdata_out;

endmodule

module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  wclk,
    input  wenc,
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0] wdata,
    input  rclk,
    input  renc,
    input  [$clog2(DEPTH)-1:0] raddr,
    output [WIDTH-1:0] rdata
);

    // Parameters
    localparam ADDR_WIDTH = $clog2(DEPTH);

    // Signals
    reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

    // Write logic
    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    // Read logic
    always @(posedge rclk) begin
        if (renc) begin
            rdata <= RAM_MEM[raddr];
        end
    end

endmodule
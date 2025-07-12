module dual_port_ram #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  logic             wclk,
    input  logic             wenc,
    input  logic [WIDTH-1:0] wdata,
    input  logic [$clog2(DEPTH)-1:0] waddr,
    input  logic             rclk,
    input  logic             renc,
    input  logic [$clog2(DEPTH)-1:0] raddr,
    output logic [WIDTH-1:0] rdata
);

    logic [WIDTH-1:0] ram [DEPTH-1:0];

    always @(posedge wclk) begin
        if (wenc) begin
            ram[waddr] <= wdata;
        end
    end

    always @(posedge rclk) begin
        if (renc) begin
            rdata <= ram[raddr];
        end
    end

endmodule

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  logic             wclk,
    input  logic             wrstn,
    input  logic             rclk,
    input  logic             rrstn,
    input  logic             winc,
    input  logic             rinc,
    input  logic [WIDTH-1:0] wdata,
    output logic             wfull,
    output logic             rempty,
    output logic [WIDTH-1:0] rdata
);

    localparam PTR_WIDTH = $clog2(DEPTH);

    logic [PTR_WIDTH-1:0] wptr_bin;
    logic [PTR_WIDTH-1:0] rptr_bin;

    logic [PTR_WIDTH-1:0] wptr_gray;
    logic [PTR_WIDTH-1:0] rptr_gray;

    logic [PTR_WIDTH-1:0] wptr_gray_sync;
    logic [PTR_WIDTH-1:0] rptr_gray_sync;

    logic wren;
    logic rden;

    assign wren = winc & ~wfull;
    assign rden = rinc & ~rempty;

    always @(posedge wclk) begin
        if (~wrstn) begin
            wptr_bin <= 0;
        end else if (winc) begin
            wptr_bin <= (wptr_bin + 1) % DEPTH;
        end
    end

    always @(posedge rclk) begin
        if (~rrstn) begin
            rptr_bin <= 0;
        end else if (rinc) begin
            rptr_bin <= (rptr_bin + 1) % DEPTH;
        end
    end

    // Gray code conversion
    assign wptr_gray = (wptr_bin >> 1) ^ wptr_bin;
    assign rptr_gray = (rptr_bin >> 1) ^ rptr_bin;

    // Two-stage synchronizer for write pointer
    logic [PTR_WIDTH-1:0] wptr_gray_sync1;
    always @(posedge rclk) begin
        wptr_gray_sync1 <= wptr_gray;
    end
    always @(posedge rclk) begin
        wptr_gray_sync <= wptr_gray_sync1;
    end

    // Two-stage synchronizer for read pointer
    logic [PTR_WIDTH-1:0] rptr_gray_sync1;
    always @(posedge wclk) begin
        rptr_gray_sync1 <= rptr_gray;
    end
    always @(posedge wclk) begin
        rptr_gray_sync <= rptr_gray_sync1;
    end

    assign wfull = (wptr_gray == (rptr_gray_sync + 1) % (1 << PTR_WIDTH));
    assign rempty = (rptr_gray == wptr_gray);

    dual_port_ram #(.WIDTH(WIDTH),.DEPTH(DEPTH)) ram_instance (
      .wclk(wclk),
      .wenc(wren),
      .wdata(wdata),
      .waddr(wptr_bin),
      .rclk(rclk),
      .renc(rden),
      .raddr(rptr_bin),
      .rdata(rdata)
    );

endmodule
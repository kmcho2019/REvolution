module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
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

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // Dual-port RAM
    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) ram (
        .wclk(wclk),
        .wenc(winc && !wfull),
        .waddr(waddr_bin[ADDR_WIDTH-1:0]),
        .wdata(wdata),
        .rclk(rclk),
        .renc(rinc && !rempty),
        .raddr(raddr_bin[ADDR_WIDTH-1:0]),
        .rdata(rdata)
    );

    // Write domain
    reg [PTR_WIDTH-1:0] waddr_bin, wptr_gray;
    reg [PTR_WIDTH-1:0] rptr_sync0, rptr_sync1;

    // Read domain
    reg [PTR_WIDTH-1:0] raddr_bin, rptr_gray;
    reg [PTR_WIDTH-1:0] wptr_sync0, wptr_sync1;

    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            waddr_bin <= 0;
            wptr_gray <= 0;
        end else if (winc && !wfull) begin
            waddr_bin <= waddr_bin + 1;
            wptr_gray <= (waddr_bin + 1) ^ ((waddr_bin + 1) >> 1);
        end
    end

    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            raddr_bin <= 0;
            rptr_gray <= 0;
        end else if (rinc && !rempty) begin
            raddr_bin <= raddr_bin + 1;
            rptr_gray <= (raddr_bin + 1) ^ ((raddr_bin + 1) >> 1);
        end
    end

    // Synchronizers
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) {rptr_sync1, rptr_sync0} <= 0;
        else {rptr_sync1, rptr_sync0} <= {rptr_sync0, rptr_gray};
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) {wptr_sync1, wptr_sync0} <= 0;
        else {wptr_sync1, wptr_sync0} <= {wptr_sync0, wptr_gray};
    end

    // Status flags
    assign wfull = (wptr_gray == {~rptr_sync1[PTR_WIDTH-1:PTR_WIDTH-2], 
                                rptr_sync1[PTR_WIDTH-3:0]});
    assign rempty = (rptr_gray == wptr_sync1);

endmodule

module dual_port_ram #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
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

    reg [WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge wclk) if (wenc) mem[waddr] <= wdata;
    always @(posedge rclk) if (renc) rdata <= mem[raddr];

endmodule
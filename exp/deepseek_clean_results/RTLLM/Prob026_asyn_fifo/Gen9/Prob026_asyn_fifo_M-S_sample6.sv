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

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // Write domain
    reg [PTR_WIDTH-1:0] wptr_bin = 0;
    reg [PTR_WIDTH-1:0] wptr_gray = 0;
    wire [PTR_WIDTH-1:0] wptr_next = wptr_bin + (winc & !wfull);

    // Read domain
    reg [PTR_WIDTH-1:0] rptr_bin = 0;
    reg [PTR_WIDTH-1:0] rptr_gray = 0;
    wire [PTR_WIDTH-1:0] rptr_next = rptr_bin + (rinc & !rempty);

    // Synchronizers
    reg [PTR_WIDTH-1:0] wptr_sync1 = 0, wptr_sync2 = 0;
    reg [PTR_WIDTH-1:0] rptr_sync1 = 0, rptr_sync2 = 0;

    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else if (winc && !wfull) begin
            wptr_bin <= wptr_next;
            wptr_gray <= wptr_next ^ (wptr_next >> 1);
        end
    end

    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else if (rinc && !rempty) begin
            rptr_bin <= rptr_next;
            rptr_gray <= rptr_next ^ (rptr_next >> 1);
        end
    end

    // Pointer synchronization
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) {wptr_sync1, wptr_sync2} <= 0;
        else {wptr_sync1, wptr_sync2} <= {wptr_gray, wptr_sync1};
    end

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) {rptr_sync1, rptr_sync2} <= 0;
        else {rptr_sync1, rptr_sync2} <= {rptr_gray, rptr_sync1};
    end

    // Flag generation
    assign wfull = (wptr_gray == {~rptr_sync2[PTR_WIDTH-1:PTR_WIDTH-2], 
                                 rptr_sync2[PTR_WIDTH-3:0]});
    assign rempty = (rptr_gray == wptr_sync2);

    // RAM interface
    dual_port_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) dp_ram (
        .wclk(wclk),
        .wenc(winc & !wfull),
        .waddr(wptr_bin[ADDR_WIDTH-1:0]),
        .wdata(wdata),
        .rclk(rclk),
        .renc(rinc & !rempty),
        .raddr(rptr_bin[ADDR_WIDTH-1:0]),
        .rdata(rdata)
    );
endmodule

module dual_port_ram #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
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
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge wclk) if (wenc) mem[waddr] <= wdata;
    always @(posedge rclk) if (renc) rdata <= mem[raddr];
endmodule
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
    output reg wfull,
    output reg rempty,
    output [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // RAM instantiation
    dp_ram #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_ram (
        .wclk(wclk),
        .wen(winc && !wfull),
        .waddr(waddr),
        .wdata(wdata),
        .rclk(rclk),
        .ren(rinc && !rempty),
        .raddr(raddr),
        .rdata(rdata)
    );

    // Write domain
    reg [PTR_WIDTH-1:0] wptr;
    wire [PTR_WIDTH-1:0] wptr_next = wptr + (winc && !wfull);
    assign waddr = wptr[ADDR_WIDTH-1:0];

    // Read domain
    reg [PTR_WIDTH-1:0] rptr;
    wire [PTR_WIDTH-1:0] rptr_next = rptr + (rinc && !rempty);
    assign raddr = rptr[ADDR_WIDTH-1:0];

    // Pointer synchronization
    reg [PTR_WIDTH-1:0] rptr_sync0, rptr_sync1;
    reg [PTR_WIDTH-1:0] wptr_sync0, wptr_sync1;

    // Adaptive synchronization
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_sync0 <= 0;
            rptr_sync1 <= 0;
            wptr <= 0;
        end else begin
            rptr_sync0 <= rptr;
            rptr_sync1 <= rptr_sync0;
            wptr <= wptr_next;
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_sync0 <= 0;
            wptr_sync1 <= 0;
            rptr <= 0;
        end else begin
            wptr_sync0 <= wptr;
            wptr_sync1 <= wptr_sync0;
            rptr <= rptr_next;
        end
    end

    // Phase-based full/empty detection
    wire wptr_msb = wptr[PTR_WIDTH-1];
    wire rptr_msb_sync = rptr_sync1[PTR_WIDTH-1];
    wire wptr_msb_sync = wptr_sync1[PTR_WIDTH-1];
    wire rptr_msb = rptr[PTR_WIDTH-1];

    // Full condition: write pointer wrapped around but read pointer hasn't
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) wfull <= 0;
        else wfull <= (wptr_next[ADDR_WIDTH-1:0] == rptr_sync1[ADDR_WIDTH-1:0]) &&
                      (wptr_msb ^ rptr_msb_sync);
    end

    // Empty condition: pointers equal and same wrap state
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) rempty <= 1;
        else rempty <= (rptr_next == wptr_sync1) ||
                       ((rptr[ADDR_WIDTH-1:0] == wptr_sync1[ADDR_WIDTH-1:0]) &&
                       (rptr_msb == wptr_msb_sync);
    end

endmodule

module dp_ram #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input wclk,
    input wen,
    input [$clog2(DEPTH)-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input ren,
    input [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);

    reg [WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge wclk) if (wen) mem[waddr] <= wdata;
    always @(posedge rclk) if (ren) rdata <= mem[raddr];

endmodule
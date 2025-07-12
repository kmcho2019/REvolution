module dual_port_RAM #(
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

    always @(posedge wclk) begin
        if (wenc) begin
            mem[waddr] <= wdata;
        end
    end

    always @(posedge rclk) begin
        if (renc) begin
            rdata <= mem[raddr];
        end
    end

endmodule

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter SYNC_STAGES = 2
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

    // Write domain signals
    reg [PTR_WIDTH-1:0] wptr_bin = 0;
    wire [PTR_WIDTH-1:0] wptr_gray;
    wire [PTR_WIDTH-1:0] wptr_next = wptr_bin + 1;
    wire [PTR_WIDTH-1:0] wptr_gray_next;

    // Read domain signals
    reg [PTR_WIDTH-1:0] rptr_bin = 0;
    wire [PTR_WIDTH-1:0] rptr_gray;
    wire [PTR_WIDTH-1:0] rptr_next = rptr_bin + 1;
    wire [PTR_WIDTH-1:0] rptr_gray_next;

    // Synchronization chains
    reg [PTR_WIDTH-1:0] rptr_gray_sync [0:SYNC_STAGES-1];
    reg [PTR_WIDTH-1:0] wptr_gray_sync [0:SYNC_STAGES-1];

    // Gray code conversions
    assign wptr_gray = wptr_bin ^ (wptr_bin >> 1);
    assign wptr_gray_next = wptr_next ^ (wptr_next >> 1);
    assign rptr_gray = rptr_bin ^ (rptr_bin >> 1);
    assign rptr_gray_next = rptr_next ^ (rptr_next >> 1);

    // RAM interface
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;

    dual_port_RAM #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_ram (
        .wclk(wclk),
        .wenc(wen),
        .waddr(wptr_bin[ADDR_WIDTH-1:0]),
        .wdata(wdata),
        .rclk(rclk),
        .renc(ren),
        .raddr(rptr_bin[ADDR_WIDTH-1:0]),
        .rdata(rdata)
    );

    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
        end else if (wen) begin
            wptr_bin <= wptr_next;
        end
    end

    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
        end else if (ren) begin
            rptr_bin <= rptr_next;
        end
    end

    // Write clock domain synchronization
    integer i;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            for (i = 0; i < SYNC_STAGES; i = i+1)
                rptr_gray_sync[i] <= 0;
        end else begin
            rptr_gray_sync[0] <= rptr_gray;
            for (i = 1; i < SYNC_STAGES; i = i+1)
                rptr_gray_sync[i] <= rptr_gray_sync[i-1];
        end
    end

    // Read clock domain synchronization
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            for (i = 0; i < SYNC_STAGES; i = i+1)
                wptr_gray_sync[i] <= 0;
        end else begin
            wptr_gray_sync[0] <= wptr_gray;
            for (i = 1; i < SYNC_STAGES; i = i+1)
                wptr_gray_sync[i] <= wptr_gray_sync[i-1];
        end
    end

    // Full/empty detection
    assign wfull = (wptr_gray == {~rptr_gray_sync[SYNC_STAGES-1][PTR_WIDTH-1:PTR_WIDTH-2], 
                                rptr_gray_sync[SYNC_STAGES-1][PTR_WIDTH-3:0]});
    assign rempty = (rptr_gray == wptr_gray_sync[SYNC_STAGES-1]);

endmodule
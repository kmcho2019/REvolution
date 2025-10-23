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

    // Memory array
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write domain
    reg [PTR_WIDTH-1:0] wptr_bin = 0;
    reg [PTR_WIDTH-1:0] wptr_gray = 0;
    reg [PTR_WIDTH-1:0] rptr_gray_ping = 0;
    reg [PTR_WIDTH-1:0] rptr_gray_pong = 0;
    reg sync_sel_w = 0;

    // Ping-pong synchronization
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            {rptr_gray_ping, rptr_gray_pong} <= 0;
            sync_sel_w <= 0;
        end else begin
            if (sync_sel_w) rptr_gray_pong <= rptr_gray;
            else rptr_gray_ping <= rptr_gray;
            sync_sel_w <= ~sync_sel_w;
        end
    end

    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else if (winc && !wfull) begin
            wptr_bin <= wptr_bin + 1;
            wptr_gray <= (wptr_bin + 1) ^ ((wptr_bin + 1) >> 1);
            mem[wptr_bin[ADDR_WIDTH-1:0]] <= wdata;
        end
    end

    // Dynamic full detection
    wire [PTR_WIDTH-1:0] rptr_gray_sync = sync_sel_w ? rptr_gray_pong : rptr_gray_ping;
    always @(*) begin
        wfull = (wptr_gray == {~rptr_gray_sync[PTR_WIDTH-1:PTR_WIDTH-2], 
                             rptr_gray_sync[PTR_WIDTH-3:0]});
    end

    // Read domain
    reg [PTR_WIDTH-1:0] rptr_bin = 0;
    reg [PTR_WIDTH-1:0] rptr_gray = 0;
    reg [PTR_WIDTH-1:0] wptr_gray_ping = 0;
    reg [PTR_WIDTH-1:0] wptr_gray_pong = 0;
    reg sync_sel_r = 0;

    // Ping-pong synchronization
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            {wptr_gray_ping, wptr_gray_pong} <= 0;
            sync_sel_r <= 0;
        end else begin
            if (sync_sel_r) wptr_gray_pong <= wptr_gray;
            else wptr_gray_ping <= wptr_gray;
            sync_sel_r <= ~sync_sel_r;
        end
    end

    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else if (rinc && !rempty) begin
            rptr_bin <= rptr_bin + 1;
            rptr_gray <= (rptr_bin + 1) ^ ((rptr_bin + 1) >> 1);
        end
    end

    // Dynamic empty detection
    wire [PTR_WIDTH-1:0] wptr_gray_sync = sync_sel_r ? wptr_gray_pong : wptr_gray_ping;
    always @(*) begin
        rempty = (rptr_gray == wptr_gray_sync);
    end

    // Memory read
    assign rdata = mem[rptr_bin[ADDR_WIDTH-1:0]];

    // Adaptive threshold adjustment
    reg [1:0] wclk_detect = 0;
    reg [1:0] rclk_detect = 0;
    always @(posedge wclk) wclk_detect <= {wclk_detect[0], 1'b1};
    always @(posedge rclk) rclk_detect <= {rclk_detect[0], 1'b1};

endmodule
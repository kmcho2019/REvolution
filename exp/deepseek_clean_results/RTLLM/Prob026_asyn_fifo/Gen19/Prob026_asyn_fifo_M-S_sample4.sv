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

    // Write domain
    reg [PTR_WIDTH-1:0] wptr_bin;
    wire [PTR_WIDTH-1:0] wptr_gray = wptr_bin ^ (wptr_bin >> 1);
    reg [PTR_WIDTH-1:0] rptr_gray_sync1, rptr_gray_sync;

    // Read domain
    reg [PTR_WIDTH-1:0] rptr_bin;
    wire [PTR_WIDTH-1:0] rptr_gray = rptr_bin ^ (rptr_bin >> 1);
    reg [PTR_WIDTH-1:0] wptr_gray_sync1, wptr_gray_sync;

    // Full/empty detection
    assign wfull = (wptr_gray == {~rptr_gray_sync[PTR_WIDTH-1:PTR_WIDTH-2], 
                                rptr_gray_sync[PTR_WIDTH-3:0]});
    assign rempty = (rptr_gray == wptr_gray_sync);

    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            {rptr_gray_sync, rptr_gray_sync1} <= 0;
        end else begin
            if (winc && !wfull) wptr_bin <= wptr_bin + 1;
            {rptr_gray_sync, rptr_gray_sync1} <= {rptr_gray_sync1, rptr_gray};
        end
    end

    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            {wptr_gray_sync, wptr_gray_sync1} <= 0;
        end else begin
            if (rinc && !rempty) rptr_bin <= rptr_bin + 1;
            {wptr_gray_sync, wptr_gray_sync1} <= {wptr_gray_sync1, wptr_gray};
        end
    end

    // Memory
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    always @(posedge wclk) if (winc && !wfull) mem[wptr_bin[ADDR_WIDTH-1:0]] <= wdata;
    always @(posedge rclk) if (rinc && !rempty) rdata <= mem[rptr_bin[ADDR_WIDTH-1:0]];

endmodule
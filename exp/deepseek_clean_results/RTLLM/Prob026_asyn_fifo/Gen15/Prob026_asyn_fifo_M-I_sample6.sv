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
    output reg [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;
    
    // Memory array
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Write domain signals
    reg [PTR_WIDTH-1:0] wptr_bin, wptr_gray;
    reg [PTR_WIDTH-1:0] rptr_sync0, rptr_sync1;
    
    // Read domain signals
    reg [PTR_WIDTH-1:0] rptr_bin, rptr_gray;
    reg [PTR_WIDTH-1:0] wptr_sync0, wptr_sync1;
    
    // Write pointer logic
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else if (!wfull && winc) begin
            wptr_bin <= wptr_bin + 1;
            wptr_gray <= wptr_bin ^ (wptr_bin >> 1);
            mem[wptr_bin[ADDR_WIDTH-1:0]] <= wdata;
        end
    end
    
    // Read pointer logic
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else if (!rempty && rinc) begin
            rptr_bin <= rptr_bin + 1;
            rptr_gray <= rptr_bin ^ (rptr_bin >> 1);
            rdata <= mem[rptr_bin[ADDR_WIDTH-1:0]];
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
    
    // Full/empty detection
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) wfull <= 0;
        else wfull <= (wptr_gray == {~rptr_sync1[PTR_WIDTH-1:PTR_WIDTH-2], 
                                   rptr_sync1[PTR_WIDTH-3:0]});
    end
    
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) rempty <= 1;
        else rempty <= (rptr_gray == wptr_sync1);
    end

endmodule
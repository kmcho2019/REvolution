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
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Write domain
    reg [PTR_WIDTH-1:0] wptr_bin = 0;
    reg [PTR_WIDTH-1:0] wptr_gray = 0;
    
    // Read domain
    reg [PTR_WIDTH-1:0] rptr_bin = 0;
    reg [PTR_WIDTH-1:0] rptr_gray = 0;
    
    // Synchronizers
    reg [PTR_WIDTH-1:0] rptr_sync [0:1];
    reg [PTR_WIDTH-1:0] wptr_sync [0:1];
    
    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else if (winc && !wfull) begin
            wptr_bin <= wptr_bin + 1;
            wptr_gray <= (wptr_bin + 1) ^ ((wptr_bin + 1) >> 1);
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
    
    // Read to write sync
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) {rptr_sync[1], rptr_sync[0]} <= 0;
        else {rptr_sync[1], rptr_sync[0]} <= {rptr_sync[0], rptr_gray};
    end
    
    // Write to read sync
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) {wptr_sync[1], wptr_sync[0]} <= 0;
        else {wptr_sync[1], wptr_sync[0]} <= {wptr_sync[0], wptr_gray};
    end
    
    // Full/empty flags
    assign wfull = (wptr_gray == {~rptr_sync[1][PTR_WIDTH-1:PTR_WIDTH-2], 
                                rptr_sync[1][PTR_WIDTH-3:0]});
    assign rempty = (rptr_gray == wptr_sync[1]);
    
    // RAM write
    always @(posedge wclk) begin
        if (winc && !wfull)
            mem[wptr_bin[ADDR_WIDTH-1:0]] <= wdata;
    end
    
    // RAM read
    always @(posedge rclk) begin
        if (rinc && !rempty)
            rdata <= mem[rptr_bin[ADDR_WIDTH-1:0]];
    end

endmodule
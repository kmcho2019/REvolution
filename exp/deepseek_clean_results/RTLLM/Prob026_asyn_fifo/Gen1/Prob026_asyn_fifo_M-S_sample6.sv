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

    // Dual-port RAM
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Write domain
    reg [ADDR_WIDTH:0] wptr_bin = 0;
    reg [ADDR_WIDTH:0] wptr_gray = 0;
    wire [ADDR_WIDTH:0] wptr_next = wptr_bin + (winc && !wfull);
    wire [ADDR_WIDTH:0] wgray_next = wptr_next ^ (wptr_next >> 1);
    
    // Read domain
    reg [ADDR_WIDTH:0] rptr_bin = 0;
    reg [ADDR_WIDTH:0] rptr_gray = 0;
    wire [ADDR_WIDTH:0] rptr_next = rptr_bin + (rinc && !rempty);
    wire [ADDR_WIDTH:0] rgray_next = rptr_next ^ (rptr_next >> 1);
    
    // Synchronizers
    reg [ADDR_WIDTH:0] rptr_sync [1:0];
    reg [ADDR_WIDTH:0] wptr_sync [1:0];
    
    // Full/empty logic
    assign wfull = (wptr_gray == {~rptr_sync[1][ADDR_WIDTH:ADDR_WIDTH-1], 
                                rptr_sync[1][ADDR_WIDTH-2:0]});
    assign rempty = (rptr_gray == wptr_sync[1]);
    
    // RAM control
    always @(posedge wclk) begin
        if (winc && !wfull) begin
            mem[wptr_bin[ADDR_WIDTH-1:0]] <= wdata;
            wptr_bin <= wptr_next;
            wptr_gray <= wgray_next;
        end
        if (!wrstn) {wptr_bin, wptr_gray} <= 0;
    end
    
    always @(posedge rclk) begin
        if (rinc && !rempty) begin
            rdata <= mem[rptr_bin[ADDR_WIDTH-1:0]];
            rptr_bin <= rptr_next;
            rptr_gray <= rgray_next;
        end
        if (!rrstn) {rptr_bin, rptr_gray} <= 0;
    end
    
    // Pointer synchronization
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) {rptr_sync[0], rptr_sync[1]} <= 0;
        else {rptr_sync[0], rptr_sync[1]} <= {rptr_gray, rptr_sync[0]};
    end
    
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) {wptr_sync[0], wptr_sync[1]} <= 0;
        else {wptr_sync[0], wptr_sync[1]} <= {wptr_gray, wptr_sync[0]};
    end

endmodule
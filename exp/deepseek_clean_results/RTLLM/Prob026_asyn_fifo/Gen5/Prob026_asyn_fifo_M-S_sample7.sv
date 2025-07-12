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
    
    // RAM interface
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;
    
    // Dual-port RAM
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    always @(posedge wclk) if (wen) mem[waddr] <= wdata;
    always @(posedge rclk) if (ren) rdata <= mem[raddr];
    
    // Pointers
    reg [ADDR_WIDTH:0] wptr_bin, rptr_bin;
    wire [ADDR_WIDTH:0] wptr_gray = wptr_bin ^ (wptr_bin >> 1);
    wire [ADDR_WIDTH:0] rptr_gray = rptr_bin ^ (rptr_bin >> 1);
    
    // Write pointer
    always @(posedge wclk or negedge wrstn)
        if (!wrstn) wptr_bin <= 0;
        else if (wen) wptr_bin <= wptr_bin + 1;
    
    // Read pointer
    always @(posedge rclk or negedge rrstn)
        if (!rrstn) rptr_bin <= 0;
        else if (ren) rptr_bin <= rptr_bin + 1;
    
    // Synchronizers
    reg [ADDR_WIDTH:0] wptr_sync1, wptr_sync2;
    reg [ADDR_WIDTH:0] rptr_sync1, rptr_sync2;
    
    always @(posedge rclk or negedge rrstn)
        if (!rrstn) {wptr_sync1, wptr_sync2} <= 0;
        else {wptr_sync1, wptr_sync2} <= {wptr_gray, wptr_sync1};
    
    always @(posedge wclk or negedge wrstn)
        if (!wrstn) {rptr_sync1, rptr_sync2} <= 0;
        else {rptr_sync1, rptr_sync2} <= {rptr_gray, rptr_sync1};
    
    // Flags
    assign wfull = (wptr_gray == {~rptr_sync2[ADDR_WIDTH:ADDR_WIDTH-1], 
                                 rptr_sync2[ADDR_WIDTH-2:0]});
    assign rempty = (rptr_gray == wptr_sync2);

endmodule
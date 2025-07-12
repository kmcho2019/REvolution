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

    // RAM signals
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;
    wire [ADDR_WIDTH-1:0] waddr, raddr;

    // Dual-port RAM
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Write port
    always @(posedge wclk) begin
        if (wen) mem[waddr] <= wdata;
    end
    
    // Read port
    always @(posedge rclk) begin
        if (ren) rdata <= mem[raddr];
    end

    // Write domain
    reg [ADDR_WIDTH:0] wptr_bin = 0, wptr_gray = 0;
    reg [ADDR_WIDTH:0] rptr_sync1 = 0, rptr_sync2 = 0;
    
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else if (wen) begin
            wptr_bin <= wptr_bin + 1;
            wptr_gray <= (wptr_bin + 1) ^ ((wptr_bin + 1) >> 1);
        end
    end
    
    // Read domain
    reg [ADDR_WIDTH:0] rptr_bin = 0, rptr_gray = 0;
    reg [ADDR_WIDTH:0] wptr_sync1 = 0, wptr_sync2 = 0;
    
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else if (ren) begin
            rptr_bin <= rptr_bin + 1;
            rptr_gray <= (rptr_bin + 1) ^ ((rptr_bin + 1) >> 1);
        end
    end

    // Pointer synchronization
    always @(posedge wclk) begin
        {rptr_sync2, rptr_sync1} <= {rptr_sync1, rptr_gray};
    end
    
    always @(posedge rclk) begin
        {wptr_sync2, wptr_sync1} <= {wptr_sync1, wptr_gray};
    end

    // Address assignment
    assign waddr = wptr_bin[ADDR_WIDTH-1:0];
    assign raddr = rptr_bin[ADDR_WIDTH-1:0];

    // Full/empty detection
    assign wfull = (wptr_gray == {~rptr_sync2[ADDR_WIDTH:ADDR_WIDTH-1], 
                                 rptr_sync2[ADDR_WIDTH-2:0]});
    assign rempty = (rptr_gray == wptr_sync2);

endmodule
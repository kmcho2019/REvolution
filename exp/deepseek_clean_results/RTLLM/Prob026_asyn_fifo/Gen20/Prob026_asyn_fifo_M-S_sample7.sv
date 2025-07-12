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
    output wire wfull,
    output wire rempty,
    output reg [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;
    
    // Memory array
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Write domain
    reg [PTR_WIDTH-1:0] wptr, wptr_gray;
    wire [PTR_WIDTH-1:0] wptr_next = wptr + 1;
    wire [PTR_WIDTH-1:0] wptr_gray_next = wptr_next ^ (wptr_next >> 1);
    
    // Read domain
    reg [PTR_WIDTH-1:0] rptr, rptr_gray;
    wire [PTR_WIDTH-1:0] rptr_next = rptr + 1;
    wire [PTR_WIDTH-1:0] rptr_gray_next = rptr_next ^ (rptr_next >> 1);
    
    // Synchronizers
    reg [PTR_WIDTH-1:0] rptr_sync1, rptr_sync2;
    reg [PTR_WIDTH-1:0] wptr_sync1, wptr_sync2;
    
    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr <= 0;
            wptr_gray <= 0;
        end else if (winc && !wfull) begin
            wptr <= wptr_next;
            wptr_gray <= wptr_gray_next;
        end
    end
    
    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr <= 0;
            rptr_gray <= 0;
        end else if (rinc && !rempty) begin
            rptr <= rptr_next;
            rptr_gray <= rptr_gray_next;
        end
    end
    
    // Write clock domain synchronization
    always @(posedge wclk) begin
        rptr_sync1 <= rptr_gray;
        rptr_sync2 <= rptr_sync1;
    end
    
    // Read clock domain synchronization
    always @(posedge rclk) begin
        wptr_sync1 <= wptr_gray;
        wptr_sync2 <= wptr_sync1;
    end
    
    // Full/empty detection
    assign wfull = (wptr_gray == {~rptr_sync2[PTR_WIDTH-1:PTR_WIDTH-2], 
                                rptr_sync2[PTR_WIDTH-3:0]});
    assign rempty = (rptr_gray == wptr_sync2);
    
    // Memory write
    always @(posedge wclk) begin
        if (winc && !wfull)
            mem[wptr[ADDR_WIDTH-1:0]] <= wdata;
    end
    
    // Memory read
    always @(posedge rclk) begin
        if (rinc && !rempty)
            rdata <= mem[rptr[ADDR_WIDTH-1:0]];
    end

endmodule
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
    reg [PTR_WIDTH-1:0] wptr, wptr_nxt;
    wire [PTR_WIDTH-1:0] wptr_gray = wptr ^ (wptr >> 1);
    
    // Read domain signals
    reg [PTR_WIDTH-1:0] rptr, rptr_nxt;
    wire [PTR_WIDTH-1:0] rptr_gray = rptr ^ (rptr >> 1);
    
    // Synchronization registers
    reg [PTR_WIDTH-1:0] rptr_sync1, rptr_sync2;
    reg [PTR_WIDTH-1:0] wptr_sync1, wptr_sync2;
    
    // Write pointer logic
    always @(*) begin
        wptr_nxt = wptr;
        if (winc && !wfull)
            wptr_nxt = wptr + 1;
    end
    
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr <= 0;
            rptr_sync1 <= 0;
            rptr_sync2 <= 0;
        end else begin
            wptr <= wptr_nxt;
            rptr_sync1 <= rptr_gray;
            rptr_sync2 <= rptr_sync1;
        end
    end
    
    // Read pointer logic
    always @(*) begin
        rptr_nxt = rptr;
        if (rinc && !rempty)
            rptr_nxt = rptr + 1;
    end
    
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr <= 0;
            wptr_sync1 <= 0;
            wptr_sync2 <= 0;
            rdata <= 0;
        end else begin
            rptr <= rptr_nxt;
            wptr_sync1 <= wptr_gray;
            wptr_sync2 <= wptr_sync1;
            if (rinc && !rempty)
                rdata <= mem[rptr[ADDR_WIDTH-1:0]];
        end
    end
    
    // Full/empty flag generation
    wire wfull_nxt = (wptr_gray == {~rptr_sync2[PTR_WIDTH-1:PTR_WIDTH-2], 
                                   rptr_sync2[PTR_WIDTH-3:0]});
    wire rempty_nxt = (rptr_gray == wptr_sync2);
    
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wfull <= 0;
        else
            wfull <= wfull_nxt;
    end
    
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rempty <= 1;
        else
            rempty <= rempty_nxt;
    end
    
    // Memory write
    always @(posedge wclk) begin
        if (winc && !wfull)
            mem[wptr[ADDR_WIDTH-1:0]] <= wdata;
    end

endmodule
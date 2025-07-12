module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter ALMOST_FULL = 2,  // Early warning threshold
    parameter ALMOST_EMPTY = 2   // Early warning threshold
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
    output reg [WIDTH-1:0] rdata,
    output wire w_almost_full,  // Early warning
    output wire r_almost_empty  // Early warning
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;
    
    // Memory array
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Write domain
    reg [PTR_WIDTH-1:0] wptr, wptr_mirror;
    wire [PTR_WIDTH-1:0] wptr_gray = wptr ^ (wptr >> 1);
    reg [PTR_WIDTH-1:0] rptr_sync;
    
    // Read domain
    reg [PTR_WIDTH-1:0] rptr, rptr_mirror;
    wire [PTR_WIDTH-1:0] rptr_gray = rptr ^ (rptr >> 1);
    reg [PTR_WIDTH-1:0] wptr_sync;
    
    // Early warning signals
    assign w_almost_full = (wptr - rptr_sync) >= (DEPTH - ALMOST_FULL);
    assign r_almost_empty = (wptr_sync - rptr) <= ALMOST_EMPTY;
    
    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr <= 0;
            wptr_mirror <= 0;
            rptr_sync <= 0;
        end else begin
            // Main pointer
            if (winc && !wfull) begin
                wptr <= wptr + 1;
                // Update mirror only when crossing sync boundary
                if (wptr[ADDR_WIDTH-1:0] == DEPTH-1)
                    wptr_mirror <= wptr + 1;
            end
            
            // Synchronized read pointer
            rptr_sync <= rptr_sync ^ (rptr_gray ^ rptr_sync);
        end
    end
    
    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr <= 0;
            rptr_mirror <= 0;
            wptr_sync <= 0;
        end else begin
            // Main pointer
            if (rinc && !rempty) begin
                rptr <= rptr + 1;
                // Update mirror only when crossing sync boundary
                if (rptr[ADDR_WIDTH-1:0] == DEPTH-1)
                    rptr_mirror <= rptr + 1;
            end
            
            // Synchronized write pointer
            wptr_sync <= wptr_sync ^ (wptr_gray ^ wptr_sync);
        end
    end
    
    // Full/empty detection
    always @(*) begin
        // Full detection (using binary in same domain)
        wfull = (wptr - rptr_mirror) >= DEPTH;
        
        // Empty detection (using Gray codes)
        rempty = (rptr_gray == wptr_sync);
    end
    
    // Memory operations
    always @(posedge wclk) begin
        if (winc && !wfull)
            mem[wptr[ADDR_WIDTH-1:0]] <= wdata;
    end
    
    always @(posedge rclk) begin
        if (rinc && !rempty)
            rdata <= mem[rptr[ADDR_WIDTH-1:0]];
        else
            rdata <= rdata;  // Hold last value
    end

endmodule
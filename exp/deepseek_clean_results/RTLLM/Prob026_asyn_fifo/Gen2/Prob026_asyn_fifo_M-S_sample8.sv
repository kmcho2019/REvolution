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
    output reg wfull,
    output reg rempty,
    output reg [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    
    // Dual-port RAM
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Write domain
    reg [ADDR_WIDTH:0] wptr;
    wire [ADDR_WIDTH:0] wptr_gray = wptr ^ (wptr >> 1);
    
    // Read domain
    reg [ADDR_WIDTH:0] rptr;
    wire [ADDR_WIDTH:0] rptr_gray = rptr ^ (rptr >> 1);
    
    // Synchronized pointers
    reg [ADDR_WIDTH:0] wptr_sync, rptr_sync;
    
    // Write control
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr <= 0;
            wfull <= 0;
        end else begin
            rptr_sync <= rptr_gray;  // Single-stage sync
            
            if (winc && !wfull) begin
                mem[wptr[ADDR_WIDTH-1:0]] <= wdata;
                wptr <= wptr + 1;
            end
            
            // Full detection
            wfull <= (wptr_gray == {~rptr_sync[ADDR_WIDTH:ADDR_WIDTH-1], 
                                   rptr_sync[ADDR_WIDTH-2:0]});
        end
    end
    
    // Read control
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr <= 0;
            rempty <= 1;
        end else begin
            wptr_sync <= wptr_gray;  // Single-stage sync
            
            if (rinc && !rempty) begin
                rdata <= mem[rptr[ADDR_WIDTH-1:0]];
                rptr <= rptr + 1;
            end
            
            // Empty detection
            rempty <= (rptr_gray == wptr_sync);
        end
    end

endmodule
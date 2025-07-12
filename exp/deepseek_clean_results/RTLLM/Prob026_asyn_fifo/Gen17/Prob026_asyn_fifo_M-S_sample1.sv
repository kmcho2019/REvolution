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
    
    // Dual-port RAM
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Write domain
    reg [PTR_WIDTH-1:0] wptr = 0;
    wire [PTR_WIDTH-1:0] wptr_gray = wptr ^ (wptr >> 1);
    
    // Read domain
    reg [PTR_WIDTH-1:0] rptr = 0;
    wire [PTR_WIDTH-1:0] rptr_gray = rptr ^ (rptr >> 1);
    
    // Synchronized pointers
    reg [PTR_WIDTH-1:0] rptr_sync = 0;
    reg [PTR_WIDTH-1:0] wptr_sync = 0;
    
    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr <= 0;
        end else if (winc && !wfull) begin
            wptr <= wptr + 1;
        end
    end
    
    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr <= 0;
        end else if (rinc && !rempty) begin
            rptr <= rptr + 1;
        end
    end
    
    // Pointer synchronization
    always @(posedge wclk) rptr_sync <= rptr_gray;
    always @(posedge rclk) wptr_sync <= wptr_gray;
    
    // Full/empty flags
    always @(*) begin
        wfull = (wptr_gray == {~rptr_sync[PTR_WIDTH-1:PTR_WIDTH-2], 
                              rptr_sync[PTR_WIDTH-3:0]});
        rempty = (rptr_gray == wptr_sync);
    end
    
    // RAM operations
    always @(posedge wclk) begin
        if (winc && !wfull)
            mem[wptr[ADDR_WIDTH-1:0]] <= wdata;
    end
    
    always @(posedge rclk) begin
        if (rinc && !rempty)
            rdata <= mem[rptr[ADDR_WIDTH-1:0]];
        else if (!rrstn)
            rdata <= 0;
    end

endmodule
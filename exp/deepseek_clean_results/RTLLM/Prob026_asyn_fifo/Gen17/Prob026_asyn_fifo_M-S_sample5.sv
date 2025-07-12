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
    
    // Memory
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Write domain
    reg [PTR_WIDTH-1:0] wptr = 0;
    reg [PTR_WIDTH-1:0] rptr_sync = 0;
    
    // Read domain
    reg [PTR_WIDTH-1:0] rptr = 0;
    reg [PTR_WIDTH-1:0] wptr_sync = 0;
    
    // Write control
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr <= 0;
        end
        else if (winc && !wfull) begin
            mem[wptr[ADDR_WIDTH-1:0]] <= wdata;
            wptr <= wptr + 1;
        end
    end
    
    // Read control
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr <= 0;
            rdata <= 0;
        end
        else if (rinc && !rempty) begin
            rdata <= mem[rptr[ADDR_WIDTH-1:0]];
            rptr <= rptr + 1;
        end
    end
    
    // Pointer synchronization
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_sync <= 0;
        end
        else begin
            rptr_sync <= rptr ^ (rptr >> 1); // Convert to Gray before sync
        end
    end
    
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_sync <= 0;
        end
        else begin
            wptr_sync <= wptr ^ (wptr >> 1); // Convert to Gray before sync
        end
    end
    
    // Flag generation
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wfull <= 0;
        end
        else begin
            wfull <= (wptr[PTR_WIDTH-1] != rptr_sync[PTR_WIDTH-1]) &&
                     (wptr[PTR_WIDTH-2:0] == rptr_sync[PTR_WIDTH-2:0]);
        end
    end
    
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rempty <= 1;
        end
        else begin
            rempty <= (rptr == wptr_sync);
        end
    end

endmodule
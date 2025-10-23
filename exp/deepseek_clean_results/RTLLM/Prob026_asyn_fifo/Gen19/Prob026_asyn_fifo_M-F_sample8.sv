module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter SYNC_STAGES = 3
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
    output reg werror,
    output reg rerror,
    output reg [1:0] wstatus,
    output reg [1:0] rstatus
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;
    
    // Memory array
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Write domain signals
    reg [PTR_WIDTH-1:0] wptr_bin = 0;
    reg [PTR_WIDTH-1:0] wptr_gray = 0;
    reg [PTR_WIDTH-1:0] rptr_gray_sync [0:SYNC_STAGES-1];
    
    // Read domain signals
    reg [PTR_WIDTH-1:0] rptr_bin = 0;
    reg [PTR_WIDTH-1:0] rptr_gray = 0;
    reg [PTR_WIDTH-1:0] wptr_gray_sync [0:SYNC_STAGES-1];
    
    // Synchronization error detection
    reg [PTR_WIDTH-1:0] wptr_gray_prev = 0;
    reg [PTR_WIDTH-1:0] rptr_gray_prev = 0;
    
    // Write control
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
            wfull <= 0;
            werror <= 0;
            wstatus <= 0;
        end
        else begin
            // Pointer update
            if (winc && !wfull) begin
                // Memory write
                if (wptr_bin[ADDR_WIDTH-1:0] < DEPTH) begin
                    mem[wptr_bin[ADDR_WIDTH-1:0]] <= wdata;
                end
                
                // Binary pointer
                wptr_bin <= wptr_bin + 1;
                
                // Gray code conversion
                wptr_gray <= (wptr_bin + 1) ^ ((wptr_bin + 1) >> 1);
            end
            
            // Full detection
            wfull <= (wptr_gray == {~rptr_gray_sync[SYNC_STAGES-1][PTR_WIDTH-1:PTR_WIDTH-2], 
                                    rptr_gray_sync[SYNC_STAGES-1][PTR_WIDTH-3:0]});
            
            // Status indicators - simplified
            if (wptr_bin == rptr_gray_sync[SYNC_STAGES-1]) begin
                wstatus <= 2'b00;  // Empty
            end else if ((wptr_bin - rptr_gray_sync[SYNC_STAGES-1]) <= DEPTH/4) begin
                wstatus <= 2'b01;  // 25% full
            end else if ((wptr_bin - rptr_gray_sync[SYNC_STAGES-1]) <= DEPTH/2) begin
                wstatus <= 2'b10;  // 50% full
            end else begin
                wstatus <= 2'b11;  // 75% full
            end
            
            // Error detection
            werror <= (wptr_gray_prev != wptr_gray) && 
                     (rptr_gray_sync[SYNC_STAGES-1] == rptr_gray_sync[SYNC_STAGES-2]);
            wptr_gray_prev <= wptr_gray;
        end
    end
    
    // Read control
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
            rempty <= 1;
            rerror <= 0;
            rstatus <= 0;
            rdata <= 0;
        end
        else begin
            // Pointer update
            if (rinc && !rempty) begin
                // Memory read
                if (rptr_bin[ADDR_WIDTH-1:0] < DEPTH) begin
                    rdata <= mem[rptr_bin[ADDR_WIDTH-1:0]];
                end
                
                // Binary pointer
                rptr_bin <= rptr_bin + 1;
                
                // Gray code conversion
                rptr_gray <= (rptr_bin + 1) ^ ((rptr_bin + 1) >> 1);
            end
            
            // Empty detection
            rempty <= (rptr_gray == wptr_gray_sync[SYNC_STAGES-1]);
            
            // Status indicators - simplified
            if (wptr_gray_sync[SYNC_STAGES-1] == rptr_bin) begin
                rstatus <= 2'b00;  // Empty
            end else if ((wptr_gray_sync[SYNC_STAGES-1] - rptr_bin) <= DEPTH/4) begin
                rstatus <= 2'b01;  // 25% used
            end else if ((wptr_gray_sync[SYNC_STAGES-1] - rptr_bin) <= DEPTH/2) begin
                rstatus <= 2'b10;  // 50% used
            end else begin
                rstatus <= 2'b11;  // 75% used
            end
            
            // Error detection
            rerror <= (rptr_gray_prev != rptr_gray) && 
                     (wptr_gray_sync[SYNC_STAGES-1] == wptr_gray_sync[SYNC_STAGES-2]);
            rptr_gray_prev <= rptr_gray;
        end
    end
    
    // Write to read synchronizer
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            for (integer i = 0; i < SYNC_STAGES; i = i + 1)
                wptr_gray_sync[i] <= 0;
        end
        else begin
            wptr_gray_sync[0] <= wptr_gray;
            for (integer i = 1; i < SYNC_STAGES; i = i + 1)
                wptr_gray_sync[i] <= wptr_gray_sync[i-1];
        end
    end
    
    // Read to write synchronizer
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            for (integer i = 0; i < SYNC_STAGES; i = i + 1)
                rptr_gray_sync[i] <= 0;
        end
        else begin
            rptr_gray_sync[0] <= rptr_gray;
            for (integer i = 1; i < SYNC_STAGES; i = i + 1)
                rptr_gray_sync[i] <= rptr_gray_sync[i-1];
        end
    end

endmodule
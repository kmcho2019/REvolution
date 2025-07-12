module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter SYNC_STAGES = 3  // Configurable synchronization depth
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
    
    // Write domain
    reg [PTR_WIDTH-1:0] wptr_bin = 0;
    reg [PTR_WIDTH-1:0] wptr_gray = 0;
    reg [PTR_WIDTH-1:0] rptr_gray_sync [0:SYNC_STAGES-1];
    
    // Read domain
    reg [PTR_WIDTH-1:0] rptr_bin = 0;
    reg [PTR_WIDTH-1:0] rptr_gray = 0;
    reg [PTR_WIDTH-1:0] wptr_gray_sync [0:SYNC_STAGES-1];
    
    // Modified Gray code encoder
    function [PTR_WIDTH-1:0] gray_enc;
        input [PTR_WIDTH-1:0] bin;
        begin
            gray_enc = (bin >> 1) ^ bin;
            // Special handling for wrap-around case
            if (bin == {PTR_WIDTH{1'b1}})
                gray_enc[PTR_WIDTH-1] = ~gray_enc[PTR_WIDTH-1];
        end
    endfunction
    
    // Write pointer control
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end
        else if (winc && !wfull) begin
            wptr_bin <= wptr_bin + 1;
            wptr_gray <= gray_enc(wptr_bin + 1);
            mem[wptr_bin[ADDR_WIDTH-1:0]] <= wdata;
        end
    end
    
    // Read pointer control
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
            rdata <= 0;
        end
        else if (rinc && !rempty) begin
            rptr_bin <= rptr_bin + 1;
            rptr_gray <= gray_enc(rptr_bin + 1);
            rdata <= mem[rptr_bin[ADDR_WIDTH-1:0]];
        end
    end
    
    // Multi-stage read pointer synchronization
    genvar i;
    generate
        for (i = 0; i < SYNC_STAGES; i = i + 1) begin : sync_rptr
            always @(posedge wclk or negedge wrstn) begin
                if (!wrstn) begin
                    if (i == 0)
                        rptr_gray_sync[i] <= 0;
                    else
                        rptr_gray_sync[i] <= rptr_gray_sync[i-1];
                end
                else begin
                    if (i == 0)
                        rptr_gray_sync[i] <= rptr_gray;
                    else
                        rptr_gray_sync[i] <= rptr_gray_sync[i-1];
                end
            end
        end
    endgenerate
    
    // Multi-stage write pointer synchronization
    generate
        for (i = 0; i < SYNC_STAGES; i = i + 1) begin : sync_wptr
            always @(posedge rclk or negedge rrstn) begin
                if (!rrstn) begin
                    if (i == 0)
                        wptr_gray_sync[i] <= 0;
                    else
                        wptr_gray_sync[i] <= wptr_gray_sync[i-1];
                end
                else begin
                    if (i == 0)
                        wptr_gray_sync[i] <= wptr_gray;
                    else
                        wptr_gray_sync[i] <= wptr_gray_sync[i-1];
                end
            end
        end
    endgenerate
    
    // Pointer validation
    wire wptr_valid = (wptr_gray_sync[SYNC_STAGES-1] ^ wptr_gray_sync[SYNC_STAGES-2]) == 
                     (wptr_gray_sync[SYNC_STAGES-2] ^ wptr_gray_sync[SYNC_STAGES-3]);
    
    wire rptr_valid = (rptr_gray_sync[SYNC_STAGES-1] ^ rptr_gray_sync[SYNC_STAGES-2]) == 
                     (rptr_gray_sync[SYNC_STAGES-2] ^ rptr_gray_sync[SYNC_STAGES-3]);
    
    // Adaptive flag generation
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wfull <= 0;
        end
        else if (wptr_valid) begin
            wfull <= ((wptr_gray ^ rptr_gray_sync[SYNC_STAGES-1]) == 
                     {1'b1, {(PTR_WIDTH-1){1'b0}}});
        end
    end
    
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rempty <= 1;
        end
        else if (rptr_valid) begin
            rempty <= (rptr_gray == wptr_gray_sync[SYNC_STAGES-1]);
        end
    end
    
    // Early warning flags (optional)
    reg almost_full, almost_empty;
    always @(posedge wclk) begin
        if (wptr_valid) begin
            almost_full <= ((wptr_bin - rptr_gray_sync[SYNC_STAGES-1]) >= (DEPTH-2));
        end
    end
    
    always @(posedge rclk) begin
        if (rptr_valid) begin
            almost_empty <= ((wptr_gray_sync[SYNC_STAGES-1] - rptr_bin) <= 1);
        end
    end

endmodule
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
    output wire wfull,
    output wire rempty,
    output reg [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;
    
    // Memory array
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Write domain signals
    reg [PTR_WIDTH-1:0] wptr_bin = 0;
    wire [PTR_WIDTH-1:0] wptr_gray = bin2gray(wptr_bin);
    wire [PTR_WIDTH-1:0] wptr_next = wptr_bin + 1;
    wire [PTR_WIDTH-1:0] wptr_gray_next = bin2gray(wptr_next);
    
    // Read domain signals
    reg [PTR_WIDTH-1:0] rptr_bin = 0;
    wire [PTR_WIDTH-1:0] rptr_gray = bin2gray(rptr_bin);
    wire [PTR_WIDTH-1:0] rptr_next = rptr_bin + 1;
    wire [PTR_WIDTH-1:0] rptr_gray_next = bin2gray(rptr_next);
    
    // Synchronization chains
    reg [PTR_WIDTH-1:0] rptr_gray_sync [0:SYNC_STAGES-1];
    reg [PTR_WIDTH-1:0] wptr_gray_sync [0:SYNC_STAGES-1];
    
    // Binary to Gray conversion
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        bin2gray = bin ^ (bin >> 1);
    endfunction
    
    // Gray to binary conversion
    function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i-1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction
    
    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
        end else if (!wfull && winc) begin
            wptr_bin <= wptr_next;
        end
    end
    
    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
        end else if (!rempty && rinc) begin
            rptr_bin <= rptr_next;
        end
    end
    
    // Synchronizer chains
    generate
        genvar i;
        // Write clock domain sync
        always @(posedge wclk or negedge wrstn) begin
            if (!wrstn) begin
                rptr_gray_sync[0] <= 0;
                for (i = 1; i < SYNC_STAGES; i = i+1)
                    rptr_gray_sync[i] <= 0;
            end else begin
                rptr_gray_sync[0] <= rptr_gray;
                for (i = 1; i < SYNC_STAGES; i = i+1)
                    rptr_gray_sync[i] <= rptr_gray_sync[i-1];
            end
        end
        
        // Read clock domain sync
        always @(posedge rclk or negedge rrstn) begin
            if (!rrstn) begin
                wptr_gray_sync[0] <= 0;
                for (i = 1; i < SYNC_STAGES; i = i+1)
                    wptr_gray_sync[i] <= 0;
            end else begin
                wptr_gray_sync[0] <= wptr_gray;
                for (i = 1; i < SYNC_STAGES; i = i+1)
                    wptr_gray_sync[i] <= wptr_gray_sync[i-1];
            end
        end
    endgenerate
    
    // Full/empty detection
    assign wfull = (wptr_gray == {~rptr_gray_sync[SYNC_STAGES-1][PTR_WIDTH-1:PTR_WIDTH-2], 
                                 rptr_gray_sync[SYNC_STAGES-1][PTR_WIDTH-3:0]});
    assign rempty = (rptr_gray == wptr_gray_sync[SYNC_STAGES-1]);
    
    // Memory operations
    always @(posedge wclk) begin
        if (!wfull && winc) begin
            mem[wptr_bin[ADDR_WIDTH-1:0]] <= wdata;
        end
    end
    
    always @(posedge rclk) begin
        if (!rempty && rinc) begin
            rdata <= mem[rptr_bin[ADDR_WIDTH-1:0]];
        end
    end

endmodule
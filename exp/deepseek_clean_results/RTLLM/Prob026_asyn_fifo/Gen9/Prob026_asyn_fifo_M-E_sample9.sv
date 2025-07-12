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
    output [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;
    
    // Memory array
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Write domain signals
    reg [PTR_WIDTH-1:0] wptr_bin = 0;
    reg [PTR_WIDTH-1:0] wptr_gray = 0;
    reg [PTR_WIDTH-1:0] rptr_gray_sync [0:2];
    
    // Read domain signals
    reg [PTR_WIDTH-1:0] rptr_bin = 0;
    reg [PTR_WIDTH-1:0] rptr_gray = 0;
    reg [PTR_WIDTH-1:0] wptr_gray_sync [0:2];
    
    // Predictive flags
    wire almost_full, almost_empty;
    
    // Binary to Gray conversion function
    function automatic [PTR_WIDTH-1:0] bin2gray;
        input [PTR_WIDTH-1:0] bin;
        bin2gray = bin ^ (bin >> 1);
    endfunction
    
    // Gray to binary conversion function
    function automatic [PTR_WIDTH-1:0] gray2bin;
        input [PTR_WIDTH-1:0] gray;
        integer i;
        begin
            gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i-1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction
    
    // Write pointer management
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else if (!wfull && winc) begin
            wptr_bin <= wptr_bin + 1;
            wptr_gray <= bin2gray(wptr_bin + 1);
        end
    end
    
    // Read pointer synchronization chain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_sync[0] <= 0;
            rptr_gray_sync[1] <= 0;
            rptr_gray_sync[2] <= 0;
        end else begin
            rptr_gray_sync[0] <= rptr_gray;
            rptr_gray_sync[1] <= rptr_gray_sync[0];
            rptr_gray_sync[2] <= rptr_gray_sync[1];
        end
    end
    
    // Full detection with hierarchical comparison
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wfull <= 0;
            almost_full <= 0;
        end else begin
            // Main full detection
            wfull <= (wptr_gray == {~rptr_gray_sync[2][PTR_WIDTH-1:PTR_WIDTH-2], 
                                   rptr_gray_sync[2][PTR_WIDTH-3:0]});
            
            // Predictive full detection
            almost_full <= (wptr_bin + 2 == gray2bin(rptr_gray_sync[2]));
        end
    end
    
    // Read pointer management
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else if (!rempty && rinc) begin
            rptr_bin <= rptr_bin + 1;
            rptr_gray <= bin2gray(rptr_bin + 1);
        end
    end
    
    // Write pointer synchronization chain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_sync[0] <= 0;
            wptr_gray_sync[1] <= 0;
            wptr_gray_sync[2] <= 0;
        end else begin
            wptr_gray_sync[0] <= wptr_gray;
            wptr_gray_sync[1] <= wptr_gray_sync[0];
            wptr_gray_sync[2] <= wptr_gray_sync[1];
        end
    end
    
    // Empty detection with hierarchical comparison
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rempty <= 1;
            almost_empty <= 1;
        end else begin
            // Main empty detection
            rempty <= (rptr_gray == wptr_gray_sync[2]);
            
            // Predictive empty detection
            almost_empty <= (rptr_bin + 2 == gray2bin(wptr_gray_sync[2]));
        end
    end
    
    // Memory write operation
    always @(posedge wclk) begin
        if (!wfull && winc) begin
            mem[wptr_bin[ADDR_WIDTH-1:0]] <= wdata;
        end
    end
    
    // Memory read operation
    always @(posedge rclk) begin
        if (!rempty && rinc) begin
            rdata <= mem[rptr_bin[ADDR_WIDTH-1:0]];
        end
    end

endmodule
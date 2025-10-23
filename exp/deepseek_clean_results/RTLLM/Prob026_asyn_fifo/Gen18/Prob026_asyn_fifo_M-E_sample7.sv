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
    
    // Write domain
    reg [PTR_WIDTH-1:0] wptr_bin;
    reg [PTR_WIDTH-1:0] wptr_gray1; // Primary Gray
    reg [PTR_WIDTH-1:0] wptr_gray2; // Secondary Gray
    wire [PTR_WIDTH-1:0] wptr_next = wptr_bin + 1'b1;
    
    // Read domain
    reg [PTR_WIDTH-1:0] rptr_bin;
    reg [PTR_WIDTH-1:0] rptr_gray1; // Primary Gray
    reg [PTR_WIDTH-1:0] rptr_gray2; // Secondary Gray
    wire [PTR_WIDTH-1:0] rptr_next = rptr_bin + 1'b1;
    
    // Synchronization registers (three-stage)
    reg [PTR_WIDTH-1:0] rptr_sync [0:2];
    reg [PTR_WIDTH-1:0] wptr_sync [0:2];
    
    // Metastability detection
    reg w_metastable, r_metastable;
    
    // Gray code functions
    function [PTR_WIDTH-1:0] bin2gray1;
        input [PTR_WIDTH-1:0] bin;
        bin2gray1 = bin ^ (bin >> 1);
    endfunction
    
    function [PTR_WIDTH-1:0] bin2gray2;
        input [PTR_WIDTH-1:0] bin;
        bin2gray2 = bin ^ (bin >> 2);
    endfunction
    
    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray1 <= 0;
            wptr_gray2 <= 0;
        end else if (winc && !wfull) begin
            wptr_bin <= wptr_next;
            wptr_gray1 <= bin2gray1(wptr_next);
            wptr_gray2 <= bin2gray2(wptr_next);
        end
    end
    
    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray1 <= 0;
            rptr_gray2 <= 0;
        end else if (rinc && !rempty) begin
            rptr_bin <= rptr_next;
            rptr_gray1 <= bin2gray1(rptr_next);
            rptr_gray2 <= bin2gray2(rptr_next);
        end
    end
    
    // Pointer synchronization
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_sync[0] <= 0;
            rptr_sync[1] <= 0;
            rptr_sync[2] <= 0;
            w_metastable <= 0;
        end else begin
            rptr_sync[0] <= rptr_gray1;
            rptr_sync[1] <= rptr_sync[0];
            rptr_sync[2] <= rptr_sync[1];
            w_metastable <= (rptr_sync[1] != rptr_sync[2]);
        end
    end
    
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_sync[0] <= 0;
            wptr_sync[1] <= 0;
            wptr_sync[2] <= 0;
            r_metastable <= 0;
        end else begin
            wptr_sync[0] <= wptr_gray1;
            wptr_sync[1] <= wptr_sync[0];
            wptr_sync[2] <= wptr_sync[1];
            r_metastable <= (wptr_sync[1] != wptr_sync[2]);
        end
    end
    
    // Full/empty detection with adaptive thresholds
    always @(*) begin
        // Full condition with secondary Gray code verification
        wfull = (wptr_gray1 == {~rptr_sync[2][PTR_WIDTH-1:PTR_WIDTH-2], 
                               rptr_sync[2][PTR_WIDTH-3:0]}) &&
                (wptr_gray2[PTR_WIDTH-1:1] == rptr_sync[2][PTR_WIDTH-1:1]);
        
        // Empty condition with secondary Gray code verification
        rempty = (rptr_gray1 == wptr_sync[2]) && 
                 (rptr_gray2[PTR_WIDTH-1:1] == wptr_sync[2][PTR_WIDTH-1:1]);
        
        // Override if metastability detected
        if (w_metastable) wfull = 1'b1;
        if (r_metastable) rempty = 1'b1;
    end
    
    // Memory operations
    always @(posedge wclk) begin
        if (winc && !wfull)
            mem[wptr_bin[ADDR_WIDTH-1:0]] <= wdata;
    end
    
    always @(posedge rclk) begin
        if (!rrstn)
            rdata <= 0;
        else if (rinc && !rempty)
            rdata <= mem[rptr_bin[ADDR_WIDTH-1:0]];
    end
    
    // Pointer validation
    always @(posedge wclk) begin
        if (bin2gray1(wptr_bin) != wptr_gray1)
            $display("Warning: Write pointer Gray code mismatch");
    end
    
    always @(posedge rclk) begin
        if (bin2gray1(rptr_bin) != rptr_gray1)
            $display("Warning: Read pointer Gray code mismatch");
    end

endmodule
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

    initial begin
        if ((DEPTH & (DEPTH - 1)) != 0) begin
            $error("DEPTH must be power of 2");
            $finish;
        end
    end

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;
    
    // Memory array
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Write domain
    reg [PTR_WIDTH-1:0] wptr_bin = 0;
    reg [PTR_WIDTH-1:0] wptr_gray = 0;
    reg [PTR_WIDTH-1:0] rptr_gray_sync [0:1];
    
    // Read domain
    reg [PTR_WIDTH-1:0] rptr_bin = 0;
    reg [PTR_WIDTH-1:0] rptr_gray = 0;
    reg [PTR_WIDTH-1:0] wptr_gray_sync [0:1];
    
    // Simple Gray code encoder
    function [PTR_WIDTH-1:0] gray_enc;
        input [PTR_WIDTH-1:0] bin;
        gray_enc = (bin >> 1) ^ bin;
    endfunction
    
    // Write pointer control
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end
        else if (winc && !wfull) begin
            mem[wptr_bin[ADDR_WIDTH-1:0]] = wdata;  // Blocking write
            wptr_bin <= wptr_bin + 1;
            wptr_gray <= gray_enc(wptr_bin + 1);
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
            rdata <= mem[rptr_bin[ADDR_WIDTH-1:0]];
            rptr_bin <= rptr_bin + 1;
            rptr_gray <= gray_enc(rptr_bin + 1);
        end
    end
    
    // Two-stage read pointer synchronization
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_sync[0] <= 0;
            rptr_gray_sync[1] <= 0;
        end
        else begin
            rptr_gray_sync[0] <= rptr_gray;
            rptr_gray_sync[1] <= rptr_gray_sync[0];
        end
    end
    
    // Two-stage write pointer synchronization
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_sync[0] <= 0;
            wptr_gray_sync[1] <= 0;
        end
        else begin
            wptr_gray_sync[0] <= wptr_gray;
            wptr_gray_sync[1] <= wptr_gray_sync[0];
        end
    end
    
    // Full/empty detection with combined validation
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wfull <= 0;
        end
        else begin
            wfull <= ((wptr_gray ^ rptr_gray_sync[1]) == 
                     {1'b1, {(PTR_WIDTH-1){1'b0}}});
        end
    end
    
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rempty <= 1;
        end
        else begin
            rempty <= (rptr_gray == wptr_gray_sync[1]);
        end
    end

endmodule
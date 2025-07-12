module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter PTR_SYNC_BITS = 2  // Number of MSBs to synchronize
) (
    input wclk,
    input rclk,
    input wrstn,
    input rrstn,
    input winc,
    input rinc,
    input [WIDTH-1:0] wdata,
    output wfull,
    output rempty,
    output [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;
    localparam SEG_WIDTH = PTR_WIDTH - PTR_SYNC_BITS;
    
    // Dual-port memory
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Write domain
    reg [PTR_WIDTH-1:0] wptr_bin = 0;
    reg [PTR_WIDTH-1:0] wptr_gray = 0;
    reg [PTR_SYNC_BITS-1:0] wptr_sync_seg = 0;
    reg [SEG_WIDTH-1:0] wptr_local_seg = 0;
    
    // Read domain
    reg [PTR_WIDTH-1:0] rptr_bin = 0;
    reg [PTR_WIDTH-1:0] rptr_gray = 0;
    reg [PTR_SYNC_BITS-1:0] rptr_sync_seg = 0;
    reg [SEG_WIDTH-1:0] rptr_local_seg = 0;
    
    // Synchronized segments
    reg [PTR_SYNC_BITS-1:0] rptr_sync [0:1];
    reg [PTR_SYNC_BITS-1:0] wptr_sync [0:1];
    
    // Predictive flags
    wire wfull_next;
    wire rempty_next;
    
    // Gray code conversion functions
    function [PTR_WIDTH-1:0] bin2gray;
        input [PTR_WIDTH-1:0] bin;
        bin2gray = bin ^ (bin >> 1);
    endfunction
    
    function [PTR_WIDTH-1:0] gray2bin;
        input [PTR_WIDTH-1:0] gray;
        reg [PTR_WIDTH-1:0] bin;
        integer i;
        begin
            bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
            for (i = PTR_WIDTH-2; i >= 0; i = i-1)
                bin[i] = bin[i+1] ^ gray[i];
            gray2bin = bin;
        end
    endfunction
    
    // Write pointer management
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
            {wptr_sync_seg, wptr_local_seg} <= 0;
        end else if (winc && !wfull) begin
            // Update memory
            mem[wptr_bin[ADDR_WIDTH-1:0]] <= wdata;
            
            // Update pointer
            wptr_bin <= wptr_bin + 1;
            wptr_gray <= bin2gray(wptr_bin + 1);
            {wptr_sync_seg, wptr_local_seg} <= wptr_bin + 1;
        end
    end
    
    // Read pointer management
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
            {rptr_sync_seg, rptr_local_seg} <= 0;
            rdata <= 0;
        end else if (rinc && !rempty) begin
            // Read memory
            rdata <= mem[rptr_bin[ADDR_WIDTH-1:0]];
            
            // Update pointer
            rptr_bin <= rptr_bin + 1;
            rptr_gray <= bin2gray(rptr_bin + 1);
            {rptr_sync_seg, rptr_local_seg} <= rptr_bin + 1;
        end
    end
    
    // Cross-clock synchronization (write to read)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_sync[0] <= 0;
            wptr_sync[1] <= 0;
        end else begin
            wptr_sync[0] <= wptr_sync_seg;
            wptr_sync[1] <= wptr_sync[0];
        end
    end
    
    // Cross-clock synchronization (read to write)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_sync[0] <= 0;
            rptr_sync[1] <= 0;
        end else begin
            rptr_sync[0] <= rptr_sync_seg;
            rptr_sync[1] <= rptr_sync[0];
        end
    end
    
    // Predictive flag generation
    assign wfull_next = ((wptr_sync_seg == ~rptr_sync[1]) && 
                        (wptr_local_seg == {SEG_WIDTH{1'b1}})) ||
                       ((wptr_sync_seg == ~(rptr_sync[1] + 1)) && 
                        (wptr_local_seg == {SEG_WIDTH{1'b0}}));
    
    assign rempty_next = (rptr_sync_seg == wptr_sync[1]) && 
                         (rptr_local_seg == wptr_local_seg);
    
    // Final flag registers
    reg wfull_reg = 0;
    reg rempty_reg = 1;
    
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) wfull_reg <= 0;
        else wfull_reg <= wfull_next;
    end
    
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) rempty_reg <= 1;
        else rempty_reg <= rempty_next;
    end
    
    assign wfull = wfull_reg;
    assign rempty = rempty_reg;

endmodule
module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter GUARD_BAND = 1  // Configurable guard band size
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
    reg [PTR_WIDTH-1:0] wptr, wptr_gray;
    reg [PTR_WIDTH-1:0] rptr_sync1, rptr_sync2;
    
    // Read domain
    reg [PTR_WIDTH-1:0] rptr, rptr_gray;
    reg [PTR_WIDTH-1:0] wptr_sync1, wptr_sync2;
    
    // Guard band registers
    reg [PTR_WIDTH-1:0] wptr_guard;
    reg [PTR_WIDTH-1:0] rptr_guard;
    
    // Convert binary to Gray code
    function automatic [PTR_WIDTH-1:0] bin2gray;
        input [PTR_WIDTH-1:0] bin;
        bin2gray = bin ^ (bin >> 1);
    endfunction
    
    // Write pointer logic
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr <= 0;
            wptr_gray <= 0;
            wptr_guard <= GUARD_BAND;
        end else if (winc && !wfull) begin
            wptr <= wptr + 1;
            wptr_gray <= bin2gray(wptr + 1);
            wptr_guard <= bin2gray(wptr + 1 + GUARD_BAND);
        end
    end
    
    // Read pointer logic
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr <= 0;
            rptr_gray <= 0;
            rptr_guard <= GUARD_BAND;
        end else if (rinc && !rempty) begin
            rptr <= rptr + 1;
            rptr_gray <= bin2gray(rptr + 1);
            rptr_guard <= bin2gray(rptr + 1 + GUARD_BAND);
        end
    end
    
    // Write domain synchronizer with metastability check
    always @(posedge wclk) begin
        rptr_sync1 <= rptr_gray;
        if (rptr_sync1 === rptr_gray)  // Stability check
            rptr_sync2 <= rptr_sync1;
    end
    
    // Read domain synchronizer with metastability check
    always @(posedge rclk) begin
        wptr_sync1 <= wptr_gray;
        if (wptr_sync1 === wptr_gray)  // Stability check
            wptr_sync2 <= wptr_sync1;
    end
    
    // Hierarchical full detection
    always @(*) begin
        // First level: MSB comparison
        if (wptr_gray[PTR_WIDTH-1] != rptr_sync2[PTR_WIDTH-1] &&
            wptr_gray[PTR_WIDTH-2] == rptr_sync2[PTR_WIDTH-2]) begin
            // Second level: Full comparison with guard band
            wfull = (wptr_guard == {~rptr_sync2[PTR_WIDTH-1:PTR_WIDTH-2], 
                                   rptr_sync2[PTR_WIDTH-3:0]});
        end else begin
            wfull = 0;
        end
    end
    
    // Hierarchical empty detection
    always @(*) begin
        // First level: MSB comparison
        if (rptr_gray[PTR_WIDTH-1] == wptr_sync2[PTR_WIDTH-1]) begin
            // Second level: Full comparison with guard band
            rempty = (rptr_guard == wptr_sync2);
        end else begin
            rempty = 0;
        end
    end
    
    // Memory operations
    always @(posedge wclk) begin
        if (winc && !wfull)
            mem[wptr[ADDR_WIDTH-1:0]] <= wdata;
    end
    
    always @(posedge rclk) begin
        if (rinc && !rempty)
            rdata <= mem[rptr[ADDR_WIDTH-1:0]];
    end

endmodule
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

    // Validate DEPTH is power of 2
    initial begin
        if ((DEPTH & (DEPTH-1)) != 0) $error("DEPTH must be power of 2");
    end

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // Dual-port RAM
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Write domain signals
    reg [PTR_WIDTH-1:0] wptr_bin;
    reg [PTR_WIDTH-1:0] wptr_gray;
    reg [PTR_WIDTH-1:0] rptr_sync0, rptr_sync1;
    
    // Read domain signals
    reg [PTR_WIDTH-1:0] rptr_bin;
    reg [PTR_WIDTH-1:0] rptr_gray;
    reg [PTR_WIDTH-1:0] wptr_sync0, wptr_sync1;
    
    // Binary to Gray conversion
    function [PTR_WIDTH-1:0] bin2gray;
        input [PTR_WIDTH-1:0] bin;
        bin2gray = bin ^ (bin >> 1);
    endfunction
    
    // Write control
    wire wen = winc && !wfull;
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
            rptr_sync0 <= 0;
            rptr_sync1 <= 0;
        end else begin
            // Pointer synchronization
            rptr_sync0 <= rptr_gray;
            rptr_sync1 <= rptr_sync0;
            
            // Write operation
            if (wen) begin
                mem[waddr] <= wdata;
                wptr_bin <= wptr_bin + 1;
                wptr_gray <= bin2gray(wptr_bin + 1);
            end
        end
    end
    
    // Read control
    wire ren = rinc && !rempty;
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];
    
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
            rdata <= 0;
            wptr_sync0 <= 0;
            wptr_sync1 <= 0;
        end else begin
            // Pointer synchronization
            wptr_sync0 <= wptr_gray;
            wptr_sync1 <= wptr_sync0;
            
            // Read operation
            if (ren) begin
                rdata <= mem[raddr];
                rptr_bin <= rptr_bin + 1;
                rptr_gray <= bin2gray(rptr_bin + 1);
            end
        end
    end
    
    // Full/empty generation
    always @(*) begin
        // Full when Gray codes match except MSB
        wfull = (wptr_gray == {~rptr_sync1[PTR_WIDTH-1:PTR_WIDTH-2], 
                              rptr_sync1[PTR_WIDTH-3:0]});
        // Empty when Gray codes match exactly
        rempty = (rptr_gray == wptr_sync1);
    end

endmodule
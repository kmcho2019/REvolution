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
    output wire wfull,
    output wire rempty,
    output reg [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;
    
    // Memory array
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Gray code conversion functions
    function [PTR_WIDTH-1:0] bin2gray;
        input [PTR_WIDTH-1:0] bin;
        bin2gray = bin ^ (bin >> 1);
    endfunction
    
    // Write domain signals
    reg [PTR_WIDTH-1:0] wptr;
    wire [PTR_WIDTH-1:0] wptr_gray = bin2gray(wptr);
    wire [PTR_WIDTH-1:0] wptr_next = wptr + (winc & ~wfull);
    wire [ADDR_WIDTH-1:0] waddr = wptr[ADDR_WIDTH-1:0];
    
    // Read domain signals
    reg [PTR_WIDTH-1:0] rptr;
    wire [PTR_WIDTH-1:0] rptr_gray = bin2gray(rptr);
    wire [PTR_WIDTH-1:0] rptr_next = rptr + (rinc & ~rempty);
    wire [ADDR_WIDTH-1:0] raddr = rptr[ADDR_WIDTH-1:0];
    
    // Synchronization registers
    reg [PTR_WIDTH-1:0] rptr_sync [0:1];
    reg [PTR_WIDTH-1:0] wptr_sync [0:1];
    
    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr <= 0;
            rptr_sync[0] <= 0;
            rptr_sync[1] <= 0;
        end else begin
            wptr <= wptr_next;
            rptr_sync[0] <= rptr_gray;
            rptr_sync[1] <= rptr_sync[0];
        end
    end
    
    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr <= 0;
            wptr_sync[0] <= 0;
            wptr_sync[1] <= 0;
            rdata <= 0;
        end else begin
            rptr <= rptr_next;
            wptr_sync[0] <= wptr_gray;
            wptr_sync[1] <= wptr_sync[0];
            
            if (rinc & ~rempty)
                rdata <= mem[raddr];
        end
    end
    
    // Memory write
    always @(posedge wclk) begin
        if (winc & ~wfull)
            mem[waddr] <= wdata;
    end
    
    // Full/empty detection
    wire full_condition = (wptr_gray == {~rptr_sync[1][PTR_WIDTH-1:PTR_WIDTH-2], 
                                         rptr_sync[1][PTR_WIDTH-3:0]});
    wire empty_condition = (rptr_gray == wptr_sync[1]);
    
    assign wfull = full_condition;
    assign rempty = empty_condition;

endmodule
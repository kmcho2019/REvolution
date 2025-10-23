module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
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
    
    // RAM instantiation
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Write domain
    reg [ADDR_WIDTH:0] wptr;
    wire [ADDR_WIDTH:0] wptr_next = wptr + (winc & !wfull);
    wire [ADDR_WIDTH:0] wptr_gray = wptr_next ^ (wptr_next >> 1);
    
    // Read domain
    reg [ADDR_WIDTH:0] rptr;
    wire [ADDR_WIDTH:0] rptr_next = rptr + (rinc & !rempty);
    wire [ADDR_WIDTH:0] rptr_gray = rptr_next ^ (rptr_next >> 1);
    
    // Synchronizers
    reg [ADDR_WIDTH:0] wptr_sync, rptr_sync;
    
    // Write control
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr <= 0;
        end else if (winc & !wfull) begin
            mem[wptr[ADDR_WIDTH-1:0]] <= wdata;
            wptr <= wptr_next;
        end
    end
    
    // Read control
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr <= 0;
            rptr_sync <= 0;
        end else begin
            rptr_sync <= wptr_gray;
            if (rinc & !rempty) begin
                rdata <= mem[rptr[ADDR_WIDTH-1:0]];
                rptr <= rptr_next;
            end
        end
    end
    
    // Write sync
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_sync <= 0;
        end else begin
            wptr_sync <= rptr_gray;
        end
    end
    
    // Full/empty detection
    assign wfull = (wptr_gray == {~wptr_sync[ADDR_WIDTH:ADDR_WIDTH-1], 
                                wptr_sync[ADDR_WIDTH-2:0]});
    assign rempty = (rptr_gray == rptr_sync);

endmodule
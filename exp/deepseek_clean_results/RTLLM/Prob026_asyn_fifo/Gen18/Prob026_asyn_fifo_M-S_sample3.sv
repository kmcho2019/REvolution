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
    
    // Dual-port RAM
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Write domain
    reg [PTR_WIDTH-1:0] wptr;
    wire [PTR_WIDTH-1:0] wptr_gray = wptr ^ (wptr >> 1);
    
    // Read domain
    reg [PTR_WIDTH-1:0] rptr;
    wire [PTR_WIDTH-1:0] rptr_gray = rptr ^ (rptr >> 1);
    
    // Synchronizers
    reg [PTR_WIDTH-1:0] r2w_sync [1:0];
    reg [PTR_WIDTH-1:0] w2r_sync [1:0];
    
    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr <= 0;
        end else if (winc && !wfull) begin
            wptr <= wptr + 1;
        end
    end
    
    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr <= 0;
        end else if (rinc && !rempty) begin
            rptr <= rptr + 1;
        end
    end
    
    // Pointer synchronization
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            r2w_sync[0] <= 0;
            r2w_sync[1] <= 0;
        end else begin
            r2w_sync[0] <= rptr_gray;
            r2w_sync[1] <= r2w_sync[0];
        end
    end
    
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            w2r_sync[0] <= 0;
            w2r_sync[1] <= 0;
        end else begin
            w2r_sync[0] <= wptr_gray;
            w2r_sync[1] <= w2r_sync[0];
        end
    end
    
    // Full/empty detection
    assign wfull = (wptr_gray == {~r2w_sync[1][PTR_WIDTH-1:PTR_WIDTH-2], 
                                r2w_sync[1][PTR_WIDTH-3:0]});
    assign rempty = (rptr_gray == w2r_sync[1]);
    
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
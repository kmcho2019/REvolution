module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    // Write interface
    input wire wclk,
    input wire wrstn,
    input wire winc,
    input wire [WIDTH-1:0] wdata,
    output wire wfull,
    
    // Read interface
    input wire rclk,
    input wire rrstn,
    input wire rinc,
    output wire [WIDTH-1:0] rdata,
    output wire rempty
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;
    
    // Dual-port RAM
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Write domain signals
    reg [PTR_WIDTH-1:0] wptr_bin = 0;
    wire [PTR_WIDTH-1:0] wptr_gray;
    reg [PTR_WIDTH-1:0] wptr_gray_reg = 0;
    reg [PTR_WIDTH-1:0] rptr_gray_sync1 = 0, rptr_gray_sync2 = 0;
    
    // Read domain signals
    reg [PTR_WIDTH-1:0] rptr_bin = 0;
    wire [PTR_WIDTH-1:0] rptr_gray;
    reg [PTR_WIDTH-1:0] rptr_gray_reg = 0;
    reg [PTR_WIDTH-1:0] wptr_gray_sync1 = 0, wptr_gray_sync2 = 0;
    
    // Binary to Gray conversion
    assign wptr_gray = wptr_bin ^ (wptr_bin >> 1);
    assign rptr_gray = rptr_bin ^ (rptr_bin >> 1);
    
    // Full/empty detection
    assign wfull = (wptr_gray == {~rptr_gray_sync2[PTR_WIDTH-1:PTR_WIDTH-2], 
                                 rptr_gray_sync2[PTR_WIDTH-3:0]});
    assign rempty = (rptr_gray == wptr_gray_sync2);
    
    // Write control
    wire wen = winc && !wfull;
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    
    // Read control
    wire ren = rinc && !rempty;
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];
    
    // Write domain logic
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray_reg <= 0;
            rptr_gray_sync1 <= 0;
            rptr_gray_sync2 <= 0;
        end else begin
            // Pointer update
            if (wen) begin
                mem[waddr] <= wdata;
                wptr_bin <= wptr_bin + 1;
                wptr_gray_reg <= wptr_gray;
            end
            
            // Read pointer synchronization
            rptr_gray_sync1 <= rptr_gray;
            rptr_gray_sync2 <= rptr_gray_sync1;
        end
    end
    
    // Read domain logic
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray_reg <= 0;
            wptr_gray_sync1 <= 0;
            wptr_gray_sync2 <= 0;
            rdata <= 0;
        end else begin
            // Pointer update
            if (ren) begin
                rdata <= mem[raddr];
                rptr_bin <= rptr_bin + 1;
                rptr_gray_reg <= rptr_gray;
            end
            
            // Write pointer synchronization
            wptr_gray_sync1 <= wptr_gray_reg;
            wptr_gray_sync2 <= wptr_gray_sync1;
        end
    end

endmodule
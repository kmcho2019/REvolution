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

    // Parameter validation
    initial begin
        if (DEPTH < 2) begin
            $error("FIFO depth must be at least 2");
            $finish;
        end
    end

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;
    
    // Dual-port RAM
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Write domain signals
    reg [PTR_WIDTH-1:0] wptr_bin;
    reg [PTR_WIDTH-1:0] wptr_gray;
    wire [PTR_WIDTH-1:0] wptr_next = wptr_bin + 1'b1;
    wire [PTR_WIDTH-1:0] wptr_gray_next = wptr_next ^ (wptr_next >> 1);
    
    // Read domain signals
    reg [PTR_WIDTH-1:0] rptr_bin;
    reg [PTR_WIDTH-1:0] rptr_gray;
    wire [PTR_WIDTH-1:0] rptr_next = rptr_bin + 1'b1;
    wire [PTR_WIDTH-1:0] rptr_gray_next = rptr_next ^ (rptr_next >> 1);
    
    // Synchronized pointers
    reg [PTR_WIDTH-1:0] rptr_sync1, rptr_sync2;
    reg [PTR_WIDTH-1:0] wptr_sync1, wptr_sync2;
    
    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else if (winc && !wfull) begin
            wptr_bin <= wptr_next;
            wptr_gray <= wptr_gray_next;
        end
    end
    
    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else if (rinc && !rempty) begin
            rptr_bin <= rptr_next;
            rptr_gray <= rptr_gray_next;
        end
    end
    
    // Synchronizers
    // Read to write sync (two-stage)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_sync1 <= 0;
            rptr_sync2 <= 0;
        end else begin
            rptr_sync1 <= rptr_gray;
            rptr_sync2 <= rptr_sync1;
        end
    end
    
    // Write to read sync (two-stage)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_sync1 <= 0;
            wptr_sync2 <= 0;
        end else begin
            wptr_sync1 <= wptr_gray;
            wptr_sync2 <= wptr_sync1;
        end
    end
    
    // Full/empty detection (combinational)
    assign wfull = (wptr_gray == {~rptr_sync2[PTR_WIDTH-1:PTR_WIDTH-2], 
                                 rptr_sync2[PTR_WIDTH-3:0]});
    assign rempty = (rptr_gray == wptr_sync2);
    
    // RAM write
    always @(posedge wclk) begin
        if (winc && !wfull)
            mem[wptr_bin[ADDR_WIDTH-1:0]] <= wdata;
    end
    
    // RAM read
    always @(posedge rclk) begin
        if (!rrstn)
            rdata <= 0;
        else if (rinc && !rempty)
            rdata <= mem[rptr_bin[ADDR_WIDTH-1:0]];
    end

endmodule
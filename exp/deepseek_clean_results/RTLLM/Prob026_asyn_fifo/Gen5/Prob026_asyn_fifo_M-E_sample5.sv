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
    output [WIDTH-1:0] rdata
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // RAM Interface
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;
    wire [ADDR_WIDTH-1:0] waddr, raddr;

    // Dual-port RAM with clock gating
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    always @(posedge wclk) if (wen) mem[waddr] <= wdata;
    assign rdata = ren ? mem[raddr] : {WIDTH{1'b0}};

    // Write Domain Logic with Predictive Pointer
    reg [PTR_WIDTH-1:0] wptr_bin, wptr_gray;
    reg [PTR_WIDTH-1:0] wptr_gray_next;
    reg wclk_enable = 1'b1;
    assign waddr = wptr_bin[ADDR_WIDTH-1:0];

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
            wptr_gray_next <= 1;
            wclk_enable <= 1'b1;
        end else if (wclk_enable) begin
            if (wen) begin
                wptr_bin <= wptr_bin + 1;
                wptr_gray <= wptr_gray_next;
                wptr_gray_next <= (wptr_bin + 2) ^ ((wptr_bin + 2) >> 1);
            end
            // Clock gating when approaching full
            wclk_enable <= !(wptr_gray == {~rptr_sync[3][PTR_WIDTH-1:PTR_WIDTH-2], 
                             rptr_sync[3][PTR_WIDTH-3:0]} - 3);
        end else begin
            // Re-enable clock when space becomes available
            wclk_enable <= !(wptr_gray == {~rptr_sync[3][PTR_WIDTH-1:PTR_WIDTH-2], 
                             rptr_sync[3][PTR_WIDTH-3:0]} - 1);
        end
    end

    // Read Domain Logic with Predictive Pointer
    reg [PTR_WIDTH-1:0] rptr_bin, rptr_gray;
    reg [PTR_WIDTH-1:0] rptr_gray_next;
    reg rclk_enable = 1'b1;
    assign raddr = rptr_bin[ADDR_WIDTH-1:0];

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
            rptr_gray_next <= 1;
            rclk_enable <= 1'b1;
        end else if (rclk_enable) begin
            if (ren) begin
                rptr_bin <= rptr_bin + 1;
                rptr_gray <= rptr_gray_next;
                rptr_gray_next <= (rptr_bin + 2) ^ ((rptr_bin + 2) >> 1);
            end
            // Clock gating when approaching empty
            rclk_enable <= !(rptr_gray == wptr_sync[3] + 3);
        end else begin
            // Re-enable clock when data becomes available
            rclk_enable <= !(rptr_gray == wptr_sync[3] + 1);
        end
    end

    // Quad-Stage Synchronizers with Metastability Detection
    reg [PTR_WIDTH-1:0] wptr_sync [0:3];
    reg [PTR_WIDTH-1:0] rptr_sync [0:3];
    reg wptr_valid, rptr_valid;

    // Write to Read Sync
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_sync[0] <= 0;
            wptr_sync[1] <= 0;
            wptr_sync[2] <= 0;
            wptr_sync[3] <= 0;
            wptr_valid <= 0;
        end else begin
            wptr_sync[0] <= wptr_gray;
            wptr_sync[1] <= wptr_sync[0];
            wptr_sync[2] <= wptr_sync[1];
            wptr_sync[3] <= wptr_sync[2];
            // Metastability detection
            wptr_valid <= (wptr_sync[3] == wptr_sync[2]) && 
                         (wptr_sync[2] == wptr_sync[1]);
        end
    end

    // Read to Write Sync
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_sync[0] <= 0;
            rptr_sync[1] <= 0;
            rptr_sync[2] <= 0;
            rptr_sync[3] <= 0;
            rptr_valid <= 0;
        end else begin
            rptr_sync[0] <= rptr_gray;
            rptr_sync[1] <= rptr_sync[0];
            rptr_sync[2] <= rptr_sync[1];
            rptr_sync[3] <= rptr_sync[2];
            // Metastability detection
            rptr_valid <= (rptr_sync[3] == rptr_sync[2]) && 
                         (rptr_sync[2] == rptr_sync[1]);
        end
    end

    // Adaptive Threshold Control
    reg [1:0] threshold = 2'b01; // Default medium threshold
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            threshold <= 2'b01;
        end else begin
            // Adjust threshold based on recent activity
            if (winc && !rinc) threshold <= (threshold == 2'b11) ? 2'b11 : threshold + 1;
            else if (!winc && rinc) threshold <= (threshold == 2'b00) ? 2'b00 : threshold - 1;
        end
    end

    // Predictive Status Flags
    wire [PTR_WIDTH-1:0] wptr_next_gray = (wptr_bin + 1) ^ ((wptr_bin + 1) >> 1);
    wire [PTR_WIDTH-1:0] rptr_next_gray = (rptr_bin + 1) ^ ((rptr_bin + 1) >> 1);

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wfull <= 0;
        end else if (rptr_valid) begin
            wfull <= (wptr_gray == {~rptr_sync[3][PTR_WIDTH-1:PTR_WIDTH-2], 
                                   rptr_sync[3][PTR_WIDTH-3:0]} - threshold) ||
                    (wptr_next_gray == {~rptr_sync[3][PTR_WIDTH-1:PTR_WIDTH-2], 
                                       rptr_sync[3][PTR_WIDTH-3:0]} - threshold);
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rempty <= 1;
        end else if (wptr_valid) begin
            rempty <= (rptr_gray == wptr_sync[3] + threshold) || 
                     (rptr_next_gray == wptr_sync[3] + threshold);
        end
    end

endmodule
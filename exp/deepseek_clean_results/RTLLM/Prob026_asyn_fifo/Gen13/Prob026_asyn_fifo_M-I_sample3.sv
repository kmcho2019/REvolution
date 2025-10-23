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

    // Validate DEPTH is power of 2
    initial if ((DEPTH & (DEPTH-1)) != 0) 
        $error("DEPTH must be power of 2");

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // RAM interface
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];

    // ========== Write Domain ==========
    reg [PTR_WIDTH-1:0] wptr_bin = 0;
    reg [PTR_WIDTH-1:0] wptr_gray = 0;
    reg [PTR_WIDTH-1:0] rptr_sync [0:2];  // 3-stage synchronizer

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else if (wen) begin
            wptr_bin <= wptr_bin + 1;
            wptr_gray <= (wptr_bin + 1) ^ ((wptr_bin + 1) >> 1);  // Early Gray conversion
        end
    end

    // Synchronizer chain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_sync[0] <= 0;
            rptr_sync[1] <= 0;
            rptr_sync[2] <= 0;
        end else begin
            rptr_sync[0] <= rptr_gray;
            rptr_sync[1] <= rptr_sync[0];
            rptr_sync[2] <= rptr_sync[1];
        end
    end

    // ========== Read Domain ==========
    reg [PTR_WIDTH-1:0] rptr_bin = 0;
    reg [PTR_WIDTH-1:0] rptr_gray = 0;
    reg [PTR_WIDTH-1:0] wptr_sync [0:2];  // 3-stage synchronizer

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else if (ren) begin
            rptr_bin <= rptr_bin + 1;
            rptr_gray <= (rptr_bin + 1) ^ ((rptr_bin + 1) >> 1);  // Early Gray conversion
        end
    end

    // Synchronizer chain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_sync[0] <= 0;
            wptr_sync[1] <= 0;
            wptr_sync[2] <= 0;
        end else begin
            wptr_sync[0] <= wptr_gray;
            wptr_sync[1] <= wptr_sync[0];
            wptr_sync[2] <= wptr_sync[1];
        end
    end

    // Status generation
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) wfull <= 0;
        else wfull <= (wptr_gray == {~rptr_sync[2][PTR_WIDTH-1:PTR_WIDTH-2], 
                                    rptr_sync[2][PTR_WIDTH-3:0]});
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) rempty <= 1;
        else rempty <= (rptr_gray == wptr_sync[2]);
    end

    // Dual-port RAM implementation
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write port
    always @(posedge wclk) begin
        if (wen) mem[waddr] <= wdata;
    end

    // Read port
    always @(posedge rclk) begin
        if (ren) rdata <= mem[raddr];
    end

endmodule
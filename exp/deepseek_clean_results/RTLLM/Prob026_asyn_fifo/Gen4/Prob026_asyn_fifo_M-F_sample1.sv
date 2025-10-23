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
    initial if ((DEPTH & (DEPTH-1)) != 0) $error("DEPTH must be power of 2");

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;  // Extra bit for full/empty detection

    // RAM implementation
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    wire [ADDR_WIDTH-1:0] waddr, raddr;
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;

    // Write port
    always @(posedge wclk) begin
        if (wen) mem[waddr] <= wdata;
    end

    // Read port
    reg [WIDTH-1:0] rdata_reg;
    always @(posedge rclk) begin
        if (ren) rdata_reg <= mem[raddr];
    end
    assign rdata = rdata_reg;

    // Write pointer logic (wclk domain)
    reg [PTR_WIDTH-1:0] wptr_bin, wptr_gray;
    assign waddr = wptr_bin[ADDR_WIDTH-1:0];

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else if (wen) begin
            wptr_bin <= wptr_bin + 1;
            wptr_gray <= (wptr_bin + 1) ^ ((wptr_bin + 1) >> 1);
        end
    end

    // Read pointer logic (rclk domain)
    reg [PTR_WIDTH-1:0] rptr_bin, rptr_gray;
    assign raddr = rptr_bin[ADDR_WIDTH-1:0];

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else if (ren) begin
            rptr_bin <= rptr_bin + 1;
            rptr_gray <= (rptr_bin + 1) ^ ((rptr_bin + 1) >> 1);
        end
    end

    // Synchronize write pointer to read domain
    reg [PTR_WIDTH-1:0] wptr_sync1, wptr_sync2;
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_sync1 <= 0;
            wptr_sync2 <= 0;
        end else begin
            wptr_sync1 <= wptr_gray;
            wptr_sync2 <= wptr_sync1;
        end
    end

    // Synchronize read pointer to write domain
    reg [PTR_WIDTH-1:0] rptr_sync1, rptr_sync2;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_sync1 <= 0;
            rptr_sync2 <= 0;
        end else begin
            rptr_sync1 <= rptr_gray;
            rptr_sync2 <= rptr_sync1;
        end
    end

    // Full/empty generation
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wfull <= 0;
        end else begin
            wfull <= (wptr_gray == {~rptr_sync2[PTR_WIDTH-1:PTR_WIDTH-2], 
                                   rptr_sync2[PTR_WIDTH-3:0]});
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rempty <= 1;
        end else begin
            rempty <= (rptr_gray == wptr_sync2);
        end
    end

endmodule
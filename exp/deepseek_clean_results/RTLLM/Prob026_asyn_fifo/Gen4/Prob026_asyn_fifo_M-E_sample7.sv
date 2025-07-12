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

    // Dual-port RAM
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    always @(posedge wclk) if (wen) mem[waddr] <= wdata;
    assign rdata = ren ? mem[raddr] : {WIDTH{1'b0}};

    // Write Domain Logic
    reg [PTR_WIDTH-1:0] wptr_bin, wptr_gray;
    reg [PTR_WIDTH-1:0] wptr_gray_next;
    assign waddr = wptr_bin[ADDR_WIDTH-1:0];

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
            wptr_gray_next <= 1;
        end else if (wen) begin
            wptr_bin <= wptr_bin + 1;
            wptr_gray <= wptr_gray_next;
            wptr_gray_next <= (wptr_bin + 2) ^ ((wptr_bin + 2) >> 1);
        end
    end

    // Read Domain Logic
    reg [PTR_WIDTH-1:0] rptr_bin, rptr_gray;
    reg [PTR_WIDTH-1:0] rptr_gray_next;
    assign raddr = rptr_bin[ADDR_WIDTH-1:0];

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
            rptr_gray_next <= 1;
        end else if (ren) begin
            rptr_bin <= rptr_bin + 1;
            rptr_gray <= rptr_gray_next;
            rptr_gray_next <= (rptr_bin + 2) ^ ((rptr_bin + 2) >> 1);
        end
    end

    // Enhanced Synchronizers (Triple-stage with edge detection)
    reg [PTR_WIDTH-1:0] wptr_sync [0:2];
    reg [PTR_WIDTH-1:0] rptr_sync [0:2];
    reg [PTR_WIDTH-1:0] wptr_stable, rptr_stable;

    // Write to Read Sync
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_sync[0] <= 0;
            wptr_sync[1] <= 0;
            wptr_sync[2] <= 0;
            wptr_stable <= 0;
        end else begin
            wptr_sync[0] <= wptr_gray;
            wptr_sync[1] <= wptr_sync[0];
            wptr_sync[2] <= wptr_sync[1];
            // Edge detection for stable pointer
            if (wptr_sync[2] == wptr_sync[1])
                wptr_stable <= wptr_sync[2];
        end
    end

    // Read to Write Sync
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_sync[0] <= 0;
            rptr_sync[1] <= 0;
            rptr_sync[2] <= 0;
            rptr_stable <= 0;
        end else begin
            rptr_sync[0] <= rptr_gray;
            rptr_sync[1] <= rptr_sync[0];
            rptr_sync[2] <= rptr_sync[1];
            // Edge detection for stable pointer
            if (rptr_sync[2] == rptr_sync[1])
                rptr_stable <= rptr_sync[2];
        end
    end

    // Predictive Full/Empty Detection
    wire [PTR_WIDTH-1:0] wptr_next_gray = (wptr_bin + 1) ^ ((wptr_bin + 1) >> 1);
    wire [PTR_WIDTH-1:0] rptr_next_gray = (rptr_bin + 1) ^ ((rptr_bin + 1) >> 1);

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wfull <= 0;
        end else begin
            // Check both current and next state for early detection
            wfull <= (wptr_gray == {~rptr_stable[PTR_WIDTH-1:PTR_WIDTH-2], 
                                   rptr_stable[PTR_WIDTH-3:0]}) ||
                    (wptr_next_gray == {~rptr_stable[PTR_WIDTH-1:PTR_WIDTH-2], 
                                      rptr_stable[PTR_WIDTH-3:0]});
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rempty <= 1;
        end else begin
            // Check both current and next state for early detection
            rempty <= (rptr_gray == wptr_stable) || 
                     (rptr_next_gray == wptr_stable);
        end
    end

endmodule
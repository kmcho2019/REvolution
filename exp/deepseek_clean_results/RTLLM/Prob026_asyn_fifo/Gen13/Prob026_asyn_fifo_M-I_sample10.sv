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
    output wfull,
    output rempty,
    output [WIDTH-1:0] rdata
);

    // Validate DEPTH is power of 2
    initial if ((DEPTH & (DEPTH-1)) != 0) $error("DEPTH must be power of 2");

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;

    // Dual-port RAM implementation
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    reg [WIDTH-1:0] rdata_reg;
    assign rdata = rdata_reg;

    // Gray code conversion
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        bin2gray = bin ^ (bin >> 1);
    endfunction

    // Write domain signals
    reg [PTR_WIDTH-1:0] wptr_bin = 0;
    reg [PTR_WIDTH-1:0] wptr_gray = 0;
    wire [PTR_WIDTH-1:0] wptr_next = wptr_bin + 1;
    wire [PTR_WIDTH-1:0] wptr_gray_next = wptr_next ^ (wptr_next >> 1);

    // Read domain signals
    reg [PTR_WIDTH-1:0] rptr_bin = 0;
    reg [PTR_WIDTH-1:0] rptr_gray = 0;
    wire [PTR_WIDTH-1:0] rptr_next = rptr_bin + 1;
    wire [PTR_WIDTH-1:0] rptr_gray_next = rptr_next ^ (rptr_next >> 1);

    // Synchronization registers (2-stage)
    reg [PTR_WIDTH-1:0] rptr_sync1 = 0, rptr_sync2 = 0;
    reg [PTR_WIDTH-1:0] wptr_sync1 = 0, wptr_sync2 = 0;

    // Control signals
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;

    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else if (wen) begin
            wptr_bin <= wptr_next;
            wptr_gray <= wptr_gray_next;
            mem[wptr_bin[ADDR_WIDTH-1:0]] <= wdata;
        end
    end

    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else if (ren) begin
            rptr_bin <= rptr_next;
            rptr_gray <= rptr_gray_next;
            rdata_reg <= mem[rptr_bin[ADDR_WIDTH-1:0]];
        end
    end

    // Pointer synchronization
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) {rptr_sync2, rptr_sync1} <= 0;
        else {rptr_sync2, rptr_sync1} <= {rptr_sync1, rptr_gray};
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) {wptr_sync2, wptr_sync1} <= 0;
        else {wptr_sync2, wptr_sync1} <= {wptr_sync1, wptr_gray};
    end

    // Status flags
    assign wfull = (wptr_gray == {~rptr_sync2[PTR_WIDTH-1:PTR_WIDTH-2], 
                                 rptr_sync2[PTR_WIDTH-3:0]});
    assign rempty = (rptr_gray == wptr_sync2);

endmodule
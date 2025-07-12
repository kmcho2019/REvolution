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

    localparam ADDR_WIDTH = $clog2(DEPTH);

    // RAM interface
    wire wen = winc && !wfull;
    wire ren = rinc && !rempty;
    wire [ADDR_WIDTH-1:0] waddr, raddr;

    // Dual-port RAM
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    always @(posedge wclk) if (wen) mem[waddr] <= wdata;
    always @(posedge rclk) if (ren) rdata <= mem[raddr];

    // Write domain
    reg [ADDR_WIDTH:0] wptr_bin, wptr_gray;
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

    // Read domain
    reg [ADDR_WIDTH:0] rptr_bin, rptr_gray;
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

    // Synchronizers
    reg [ADDR_WIDTH:0] wptr_sync, rptr_sync;

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_sync <= 0;
            rempty <= 1;
        end else begin
            wptr_sync <= wptr_gray;
            rempty <= (rptr_gray == wptr_sync);
        end
    end

    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_sync <= 0;
            wfull <= 0;
        end else begin
            rptr_sync <= rptr_gray;
            wfull <= (wptr_gray == {~rptr_sync[ADDR_WIDTH:ADDR_WIDTH-1], 
                                   rptr_sync[ADDR_WIDTH-2:0]});
        end
    end

endmodule
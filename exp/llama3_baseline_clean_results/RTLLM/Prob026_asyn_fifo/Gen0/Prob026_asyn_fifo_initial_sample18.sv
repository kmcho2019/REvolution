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
    output reg [WIDTH-1:0] rdata
);

    reg [WIDTH-1:0] ram_mem [DEPTH-1:0];

    // Write pointer logic
    reg [$clog2(DEPTH)-1:0] waddr_bin;
    reg [$clog2(DEPTH)-1:0] wptr_bin;
    reg [$clog2(DEPTH)-1:0] wptr_bin_buff;

    always @(posedge wclk) begin
        if (~wrstn) begin
            waddr_bin <= 0;
        end else if (winc) begin
            waddr_bin <= waddr_bin + 1;
        end
    end

    always @(posedge wclk) begin
        wptr_bin <= waddr_bin;
    end

    always @(posedge wclk) begin
        wptr_bin_buff <= wptr_bin;
    end

    // Read pointer logic
    reg [$clog2(DEPTH)-1:0] raddr_bin;
    reg [$clog2(DEPTH)-1:0] rptr_bin;
    reg [$clog2(DEPTH)-1:0] rptr_bin_buff;

    always @(posedge rclk) begin
        if (~rrstn) begin
            raddr_bin <= 0;
        end else if (rinc) begin
            raddr_bin <= raddr_bin + 1;
        end
    end

    always @(posedge rclk) begin
        rptr_bin <= raddr_bin;
    end

    always @(posedge rclk) begin
        rptr_bin_buff <= rptr_bin;
    end

    // Gray code conversion
    wire [$clog2(DEPTH)-1:0] wptr;
    wire [$clog2(DEPTH)-1:0] rptr;

    assign wptr = (wptr_bin >> 1) ^ wptr_bin;
    assign rptr = (rptr_bin >> 1) ^ rptr_bin;

    // Synchronization of read and write pointers
    reg [$clog2(DEPTH)-1:0] rptr_syn;
    reg [$clog2(DEPTH)-1:0] wptr_syn;

    always @(posedge wclk) begin
        rptr_syn <= rptr_bin_buff;
    end

    always @(posedge rclk) begin
        wptr_syn <= wptr_bin_buff;
    end

    // Full and empty detection
    assign wfull = (wptr == (~rptr_syn[$clog2(DEPTH)-1] & rptr_syn[$clog2(DEPTH)-2:0]));
    assign rempty = (rptr_bin == wptr_syn);

    // RAM operations
    always @(posedge wclk) begin
        if (winc) begin
            ram_mem[wptr_bin] <= wdata;
        end
    end

    always @(posedge rclk) begin
        rdata <= ram_mem[rptr_bin];
    end

endmodule
module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input wclk,  // Write clock signal
    input rclk,  // Read clock signal
    input wrstn, // Write reset signal (0 for reset, 1 for reset inactive)
    input rrstn, // Read reset signal (0 for reset, 1 for reset inactive)
    input winc,  // Write increment signal
    input rinc,  // Read increment signal
    input [WIDTH-1:0] wdata, // Write data input
    output wfull, // Write full signal
    output rempty, // Read empty signal
    output [WIDTH-1:0] rdata  // Read data output
);

    // Calculate the width of the address
    localparam ADDR_WIDTH = $clog2(DEPTH);

    // Dual-port RAM
    reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

    // Write and read pointers
    reg [ADDR_WIDTH-1:0] waddr_bin, raddr_bin;

    // Gray code conversion
    reg [ADDR_WIDTH-1:0] wptr, rptr;

    // Buffer registers
    reg [ADDR_WIDTH-1:0] wptr_buff, rptr_buff;

    // Synchronized read pointer
    reg [ADDR_WIDTH-1:0] rptr_syn;

    // Write enable and read enable
    reg wen, ren;

    // Write data output
    reg [WIDTH-1:0] wdata_out;

    // Read data input
    reg [WIDTH-1:0] rdata_in;

    // Full and empty signals
    assign wfull = (wptr == {~rptr_syn[ADDR_WIDTH-1], rptr_syn[ADDR_WIDTH-2:0]});
    assign rempty = (rptr == wptr);

    // Write pointer increment
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            waddr_bin <= 0;
        end else if (winc) begin
            waddr_bin <= (waddr_bin + 1) % DEPTH;
        end
    end

    // Read pointer increment
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            raddr_bin <= 0;
        end else if (rinc) begin
            raddr_bin <= (raddr_bin + 1) % DEPTH;
        end
    end

    // Gray code conversion for write pointer
    always @(posedge wclk) begin
        wptr <= waddr_bin ^ (waddr_bin >> 1);
    end

    // Gray code conversion for read pointer
    always @(posedge rclk) begin
        rptr <= raddr_bin ^ (raddr_bin >> 1);
    end

    // Write data output
    always @(posedge wclk) begin
        if (winc) begin
            RAM_MEM[waddr_bin] <= wdata;
        end
    end

    // Read data input
    always @(posedge rclk) begin
        rdata_in <= RAM_MEM[raddr_bin];
    end

    // Buffer registers
    always @(posedge wclk) begin
        wptr_buff <= wptr;
    end

    always @(posedge rclk) begin
        rptr_buff <= rptr;
    end

    // Read pointer synchronizer
    reg [ADDR_WIDTH-1:0] rptr_sync1, rptr_sync2;
    always @(posedge wclk) begin
        rptr_sync1 <= rptr_buff;
        rptr_sync2 <= rptr_sync1;
    end
    assign rptr_syn = rptr_sync2;

    // Write pointer synchronizer
    reg [ADDR_WIDTH-1:0] wptr_sync1, wptr_sync2;
    always @(posedge rclk) begin
        wptr_sync1 <= wptr_buff;
        wptr_sync2 <= wptr_sync1;
    end

    // Write enable and read enable
    always @(posedge wclk) begin
        wen <= winc;
    end

    always @(posedge rclk) begin
        ren <= rinc;
    end

    // Assign output signals
    assign rdata = rdata_in;

endmodule
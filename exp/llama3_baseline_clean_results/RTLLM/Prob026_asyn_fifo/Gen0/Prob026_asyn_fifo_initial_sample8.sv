module asyn_fifo(
    input  wclk, 
    input  rclk, 
    input  wrstn, 
    input  rrstn, 
    input  winc, 
    input  rinc, 
    input  [WIDTH-1:0] wdata, 
    output reg wfull, 
    output reg rempty, 
    output reg [WIDTH-1:0] rdata
);

    parameter WIDTH = 8;
    parameter DEPTH = 16;

    // Calculate the width of the write and read pointers
    parameter PTR_WIDTH = $clog2(DEPTH);

    // Dual-port RAM
    reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];
    reg [PTR_WIDTH-1:0] waddr_bin;
    reg [PTR_WIDTH-1:0] raddr_bin;
    reg [WIDTH-1:0] rdata_reg;

    always @(posedge wclk) begin
        if (~wrstn) begin
            waddr_bin <= 0;
        end else if (winc) begin
            waddr_bin <= waddr_bin + 1;
        end
    end

    always @(posedge rclk) begin
        if (~rrstn) begin
            raddr_bin <= 0;
        end else if (rinc) begin
            raddr_bin <= raddr_bin + 1;
        end
    end

    // Gray code conversion
    reg [PTR_WIDTH-1:0] wptr;
    reg [PTR_WIDTH-1:0] rptr;
    reg [PTR_WIDTH-1:0] wptr_syn;
    reg [PTR_WIDTH-1:0] rptr_syn;

    always @(posedge wclk) begin
        wptr <= waddr_bin ^ (waddr_bin >> 1);
    end

    always @(posedge rclk) begin
        rptr <= raddr_bin ^ (raddr_bin >> 1);
    end

    // Pointer synchronizer
    reg [PTR_WIDTH-1:0] wptr_buff;
    reg [PTR_WIDTH-1:0] rptr_buff;

    always @(posedge rclk) begin
        if (~rrstn) begin
            wptr_buff <= 0;
            wptr_syn <= 0;
        end else begin
            wptr_buff <= wptr;
            wptr_syn <= wptr_buff;
        end
    end

    always @(posedge wclk) begin
        if (~wrstn) begin
            rptr_buff <= 0;
            rptr_syn <= 0;
        end else begin
            rptr_buff <= rptr;
            rptr_syn <= rptr_buff;
        end
    end

    // Full and empty signals
    always @(posedge wclk) begin
        if (wptr == {~rptr_syn[PTR_WIDTH-1], rptr_syn[PTR_WIDTH-2:0]}) begin
            wfull <= 1'b1;
        end else begin
            wfull <= 1'b0;
        end
    end

    always @(posedge rclk) begin
        if (rptr == wptr_syn) begin
            rempty <= 1'b1;
        end else begin
            rempty <= 1'b0;
        end
    end

    // Read and write operations
    always @(posedge wclk) begin
        if (winc && ~wfull) begin
            RAM_MEM[waddr_bin] <= wdata;
        end
    end

    always @(posedge rclk) begin
        if (rinc && ~rempty) begin
            rdata_reg <= RAM_MEM[raddr_bin];
        end
    end

    assign rdata = rdata_reg;

endmodule
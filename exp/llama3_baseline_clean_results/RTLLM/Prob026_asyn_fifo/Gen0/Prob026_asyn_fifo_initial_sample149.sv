module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  wclk, 
    input  rstn, 
    input  rclk, 
    input  wrstn,
    input  rrstn,
    input  winc, 
    input  rinc, 
    input  [WIDTH-1:0] wdata, 
    output reg  wfull, 
    output reg  rempty, 
    output reg [WIDTH-1:0] rdata
);

    // Dual-port RAM module
    reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];
    reg [$clog2(DEPTH)-1:0] waddr_bin;
    reg [$clog2(DEPTH)-1:0] raddr_bin;
    reg [WIDTH-1:0] rdata_int;

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
    reg [$clog2(DEPTH)-1:0] wptr;
    reg [$clog2(DEPTH)-1:0] rptr;
    reg [$clog2(DEPTH)-1:0] wptr_syn;
    reg [$clog2(DEPTH)-1:0] rptr_syn;

    always @(posedge wclk) begin
        wptr <= waddr_bin ^ (waddr_bin >> 1);
    end

    always @(posedge rclk) begin
        rptr <= raddr_bin ^ (raddr_bin >> 1);
    end

    // Pointer synchronizers
    reg [$clog2(DEPTH)-1:0] wptr_buff;
    reg [$clog2(DEPTH)-1:0] rptr_buff;

    always @(posedge rclk) begin
        wptr_syn <= wptr_buff;
    end

    always @(posedge wclk) begin
        rptr_buff <= rptr;
    end

    always @(posedge wclk) begin
        wptr_buff <= wptr;
    end

    // Full and empty judgment
    always @(posedge wclk) begin
        if (wptr_syn == (~rptr_syn[$clog2(DEPTH)-1] & {rptr_syn[$clog2(DEPTH)-2:0]})) begin
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

    // Data write and read operations
    always @(posedge wclk) begin
        if (winc & ~wfull) begin
            RAM_MEM[waddr_bin] <= wdata;
        end
    end

    always @(posedge rclk) begin
        if (~rempty) begin
            rdata_int <= RAM_MEM[raddr_bin];
        end
    end

    assign rdata = rdata_int;

endmodule
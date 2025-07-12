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

    // Dual-port RAM
    reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

    // Write and Read Pointers
    reg [$clog2(DEPTH)-1:0] waddr_bin;
    reg [$clog2(DEPTH)-1:0] raddr_bin;

    // Gray Code Conversion
    wire [$clog2(DEPTH)-1:0] wptr;
    wire [$clog2(DEPTH)-1:0] rptr;
    reg  [$clog2(DEPTH)-1:0] wptr_buff;
    reg  [$clog2(DEPTH)-1:0] rptr_buff;

    // Pointer Synchronizers
    reg [$clog2(DEPTH)-1:0] rptr_syn;
    reg [$clog2(DEPTH)-1:0] wptr_syn;

    // Full and Empty Signals
    reg wfull_reg;
    reg rempty_reg;

    // Dual-port RAM ports
    assign wenc = winc;
    assign renc = rinc;
    assign waddr = wptr_buff[$clog2(DEPTH)-2:0];
    assign raddr = rptr_buff[$clog2(DEPTH)-2:0];

    // Write Pointer Increment
    always @(posedge wclk or negedge wrstn)
    begin
        if (~wrstn) begin
            waddr_bin <= 0;
        end
        else if (winc) begin
            waddr_bin <= waddr_bin + 1;
        end
    end

    // Read Pointer Increment
    always @(posedge rclk or negedge rrstn)
    begin
        if (~rrstn) begin
            raddr_bin <= 0;
        end
        else if (rinc) begin
            raddr_bin <= raddr_bin + 1;
        end
    end

    // Gray Code Conversion
    assign wptr = waddr_bin ^ (waddr_bin >> 1);
    assign rptr = raddr_bin ^ (raddr_bin >> 1);

    // Pointer Buffers
    always @(posedge wclk or negedge wrstn)
    begin
        if (~wrstn) begin
            wptr_buff <= 0;
        end
        else begin
            wptr_buff <= wptr;
        end
    end

    always @(posedge rclk or negedge rrstn)
    begin
        if (~rrstn) begin
            rptr_buff <= 0;
        end
        else begin
            rptr_buff <= rptr;
        end
    end

    // Read Pointer Synchronizer
    always @(posedge wclk or negedge wrstn)
    begin
        if (~wrstn) begin
            rptr_syn <= 0;
        end
        else begin
            rptr_syn <= rptr_buff;
        end
    end

    // Write Pointer Synchronizer
    always @(posedge rclk or negedge rrstn)
    begin
        if (~rrstn) begin
            wptr_syn <= 0;
        end
        else begin
            wptr_syn <= wptr_buff;
        end
    end

    // Full and Empty Signals
    always @(*)
    begin
        if (wptr_buff == {~rptr_buff[$clog2(DEPTH)-1], rptr_buff[$clog2(DEPTH)-2:0]}) begin
            wfull_reg = 1;
        end
        else begin
            wfull_reg = 0;
        end

        if (rptr_buff == wptr_buff) begin
            rempty_reg = 1;
        end
        else begin
            rempty_reg = 0;
        end
    end

    // Output Assignments
    assign wfull = wfull_reg;
    assign rempty = rempty_reg;

    // Dual-port RAM
    always @(posedge wclk)
    begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    always @(posedge rclk)
    begin
        if (renc) begin
            rdata <= RAM_MEM[raddr];
        end
    end

endmodule
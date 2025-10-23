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

    // Ring Buffer
    reg [$clog2(DEPTH)-1:0] wptr;
    reg [$clog2(DEPTH)-1:0] rptr;
    reg [WIDTH-1:0] ring_buffer [DEPTH-1:0];

    // Dual-port RAM
    reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

    // Synchronization Mechanism
    reg [$clog2(DEPTH)-1:0] wptr_syn;
    reg [$clog2(DEPTH)-1:0] rptr_syn;

    // Empty and Full Conditions
    reg wfull_reg;
    reg rempty_reg;

    // Write Pointer Increment
    always @(posedge wclk or negedge wrstn)
    begin
        if (~wrstn) begin
            wptr <= 0;
        end
        else if (winc) begin
            wptr <= (wptr + 1) % DEPTH;
        end
    end

    // Read Pointer Increment
    always @(posedge rclk or negedge rrstn)
    begin
        if (~rrstn) begin
            rptr <= 0;
        end
        else if (rinc) begin
            rptr <= (rptr + 1) % DEPTH;
        end
    end

    // Write Operation
    always @(posedge wclk)
    begin
        if (winc) begin
            ring_buffer[wptr] <= wdata;
            RAM_MEM[wptr] <= wdata;
        end
    end

    // Read Operation
    always @(posedge rclk)
    begin
        if (rinc) begin
            rdata <= RAM_MEM[rptr];
        end
    end

    // Synchronization Mechanism
    always @(posedge wclk or negedge wrstn)
    begin
        if (~wrstn) begin
            wptr_syn <= 0;
        end
        else begin
            wptr_syn <= wptr;
        end
    end

    always @(posedge rclk or negedge rrstn)
    begin
        if (~rrstn) begin
            rptr_syn <= 0;
        end
        else begin
            rptr_syn <= rptr;
        end
    end

    // Empty and Full Conditions
    always @(*)
    begin
        if (wptr == rptr) begin
            rempty_reg <= 1;
        end
        else begin
            rempty_reg <= 0;
        end

        if ((wptr + 1) % DEPTH == rptr) begin
            wfull_reg <= 1;
        end
        else begin
            wfull_reg <= 0;
        end
    end

    // Output Assignments
    assign wfull = wfull_reg;
    assign rempty = rempty_reg;

endmodule
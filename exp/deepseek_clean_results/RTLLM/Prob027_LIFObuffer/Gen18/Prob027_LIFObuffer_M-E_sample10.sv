module LIFObuffer (
    input wire [3:0] dataIn,
    input wire RW,
    input wire EN,
    input wire Rst,
    input wire Clk,
    output wire EMPTY,
    output wire FULL,
    output reg [3:0] dataOut
);

    // Circular stack memory (4 entries)
    reg [3:0] stack_mem [0:3];
    
    // Circular pointers (2 bits each)
    reg [1:0] w_ptr;  // Write pointer (next push location)
    reg [1:0] r_ptr;  // Read pointer (next pop location)
    
    // Operation control
    wire push_op = EN && !RW;
    wire pop_op = EN && RW;
    
    // Status flags (combinational)
    assign EMPTY = (w_ptr == r_ptr);
    assign FULL = ((w_ptr + 1) == r_ptr);
    
    // Early output during read operations
    always @(*) begin
        if (pop_op && !EMPTY)
            dataOut = stack_mem[r_ptr];
    end
    
    // Stack operations
    always @(posedge Clk) begin
        if (Rst) begin
            w_ptr <= 0;
            r_ptr <= 0;
            stack_mem[0] <= 0;
            stack_mem[1] <= 0;
            stack_mem[2] <= 0;
            stack_mem[3] <= 0;
        end
        else begin
            // Push operation (write and advance w_ptr)
            if (push_op && !FULL) begin
                stack_mem[w_ptr] <= dataIn;
                w_ptr <= w_ptr + 1;
            end
            
            // Pop operation (advance r_ptr)
            if (pop_op && !EMPTY) begin
                r_ptr <= r_ptr + 1;
            end
            
            // Synchronous output (fallback)
            if (!pop_op || EMPTY)
                dataOut <= dataOut;
        end
    end

endmodule
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

    // Stack memory array (4 entries of 4 bits each)
    reg [3:0] stack_mem [0:3];
    
    // Pointers (2 bits each for 4-entry buffer)
    reg [1:0] head_ptr, tail_ptr;
    
    // Internal signals
    wire do_push = EN && !RW;
    wire do_pop = EN && RW;
    wire ptr_equal = (head_ptr == tail_ptr);
    wire head_next = (head_ptr + 1) == tail_ptr;
    
    // Flag generation
    assign EMPTY = ptr_equal;
    assign FULL = head_next;
    
    // Buffer operations
    always @(posedge Clk) begin
        if (Rst) begin
            head_ptr <= 2'b00;
            tail_ptr <= 2'b00;
            dataOut <= 4'b0;
            // Optional memory clear
            // stack_mem[0] <= 4'b0;
            // stack_mem[1] <= 4'b0;
            // stack_mem[2] <= 4'b0;
            // stack_mem[3] <= 4'b0;
        end
        else begin
            // Push operation
            if (do_push && !FULL) begin
                stack_mem[head_ptr] <= dataIn;
                head_ptr <= head_ptr + 1;
                if (head_ptr == 2'b11) head_ptr <= 2'b00;
            end
            
            // Pop operation
            if (do_pop && !EMPTY) begin
                dataOut <= stack_mem[tail_ptr];
                tail_ptr <= tail_ptr + 1;
                if (tail_ptr == 2'b11) tail_ptr <= 2'b00;
            end
        end
    end

endmodule
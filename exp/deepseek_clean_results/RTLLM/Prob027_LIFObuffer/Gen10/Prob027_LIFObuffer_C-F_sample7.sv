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
    
    // Stack pointer (2 bits sufficient for 4 entries)
    reg [1:0] SP;
    reg empty_flag;
    
    // Operation control signals
    wire push_op = EN && !RW;
    wire pop_op = EN && RW;
    wire valid_push = push_op && !FULL;
    wire valid_pop = pop_op && !EMPTY;
    
    // Combinational flag generation
    assign EMPTY = empty_flag;
    assign FULL = (!empty_flag && &SP); // SP == 2'b11 when full
    
    // Next state and memory operations
    always @(posedge Clk) begin
        if (Rst) begin
            // Reset condition
            SP <= 2'b00;
            empty_flag <= 1'b1;
            stack_mem[0] <= 4'b0;
            stack_mem[1] <= 4'b0;
            stack_mem[2] <= 4'b0;
            stack_mem[3] <= 4'b0;
            dataOut <= 4'b0;
        end
        else begin
            if (valid_push) begin
                // Push operation
                if (empty_flag) begin
                    stack_mem[0] <= dataIn;
                    empty_flag <= 1'b0;
                end
                else begin
                    stack_mem[SP + 1] <= dataIn;
                    SP <= SP + 1;
                end
            end
            else if (valid_pop) begin
                // Pop operation
                dataOut <= stack_mem[SP];
                if (SP == 2'b00) begin
                    empty_flag <= 1'b1;
                end
                else begin
                    SP <= SP - 1;
                end
            end
        end
    end

endmodule
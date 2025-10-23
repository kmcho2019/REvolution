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
    
    // Stack pointer (2 bits for 4 entries)
    reg [1:0] SP;
    
    // Combinational flag generation
    assign EMPTY = (SP == 2'b00);
    assign FULL = (SP == 2'b11);
    
    // Operation control signals
    wire push_op = EN && !RW && !FULL;
    wire pop_op = EN && RW && !EMPTY;
    
    // Stack operations
    always @(posedge Clk) begin
        if (Rst) begin
            // Reset clears all memory and pointer
            SP <= 2'b00;
            stack_mem[0] <= 4'b0;
            stack_mem[1] <= 4'b0;
            stack_mem[2] <= 4'b0;
            stack_mem[3] <= 4'b0;
        end
        else begin
            if (push_op) begin
                // Push operation
                stack_mem[SP] <= dataIn;
                SP <= SP + 1;
            end
            else if (pop_op) begin
                // Pop operation
                dataOut <= stack_mem[SP-1];
                SP <= SP - 1;
            end
        end
    end

endmodule
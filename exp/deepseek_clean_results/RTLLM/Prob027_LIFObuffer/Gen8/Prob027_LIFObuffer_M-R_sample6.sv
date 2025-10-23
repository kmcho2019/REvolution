module LIFObuffer (
    input wire [3:0] dataIn,
    input wire RW,
    input wire EN,
    input wire Rst,
    input wire Clk,
    output wire EMPTY,
    output wire FULL,
    output wire [3:0] dataOut
);

    // Stack memory array (4 entries of 4 bits each)
    reg [3:0] stack_mem [0:3];
    // Stack pointer (0-4)
    reg [2:0] SP;
    
    // Next state signals
    wire [2:0] next_SP;
    wire stack_push, stack_pop;
    
    // Operation validity
    assign stack_push = EN && !RW && !FULL;
    assign stack_pop = EN && RW && !EMPTY;
    
    // Flag generation (combinational)
    assign EMPTY = (SP == 3'd4);
    assign FULL = (SP == 3'd0);
    
    // Data output (combinational)
    assign dataOut = stack_mem[SP];
    
    // Next SP calculation (combinational)
    assign next_SP = Rst ? 3'd4 : 
                    stack_push ? SP - 1 :
                    stack_pop ? SP + 1 :
                    SP;
    
    // Memory and SP update (sequential)
    always @(posedge Clk) begin
        SP <= next_SP;
        
        if (Rst) begin
            // Clear memory on reset
            stack_mem[0] <= 4'b0;
            stack_mem[1] <= 4'b0;
            stack_mem[2] <= 4'b0;
            stack_mem[3] <= 4'b0;
        end
        else if (stack_push) begin
            // Write operation (push)
            stack_mem[SP-1] <= dataIn;
        end
        else if (stack_pop) begin
            // Clear popped location (optional)
            stack_mem[SP] <= 4'b0;
        end
    end

endmodule
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

    // One-hot encoded stack pointer (5 states: 4 positions + empty)
    reg [4:0] SP;  // Bit positions: [4]empty, [3:0]stack levels
    
    // Stack memory (4 entries of 4 bits each)
    reg [3:0] stack_mem [0:3];
    
    // Combinational flag assignments
    assign EMPTY = SP[4];
    assign FULL = (SP == 5'b00001);  // Only SP[0] is set
    
    // Next stack pointer logic
    wire [4:0] next_SP;
    assign next_SP = Rst ? 5'b10000 :        // Reset to empty
                    (!EN) ? SP :             // Hold when disabled
                    (!RW && !FULL) ? {1'b0, SP[3:0] >> 1} :  // Push (shift right)
                    (RW && !EMPTY) ? {SP[4] | (&SP[3:1]), SP[3:0] << 1} :  // Pop (shift left)
                    SP;
    
    // Stack pointer update
    always @(posedge Clk) begin
        SP <= next_SP;
    end
    
    // Memory operations
    always @(posedge Clk) begin
        if (Rst) begin
            // Optional memory clear
            stack_mem[0] <= 4'b0;
            stack_mem[1] <= 4'b0;
            stack_mem[2] <= 4'b0;
            stack_mem[3] <= 4'b0;
            dataOut <= 4'b0;
        end
        else if (EN) begin
            // Push operation
            if (!RW && !FULL) begin
                case (SP)
                    5'b01000: stack_mem[0] <= dataIn;
                    5'b00100: stack_mem[1] <= dataIn;
                    5'b00010: stack_mem[2] <= dataIn;
                    5'b00001: stack_mem[3] <= dataIn;
                endcase
            end
            // Pop operation
            else if (RW && !EMPTY) begin
                case (SP)
                    5'b10000: ; // Empty, do nothing
                    5'b01000: dataOut <= stack_mem[0];
                    5'b00100: dataOut <= stack_mem[1];
                    5'b00010: dataOut <= stack_mem[2];
                    5'b00001: dataOut <= stack_mem[3];
                endcase
            end
        end
    end

endmodule
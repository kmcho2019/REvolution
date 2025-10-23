module LIFObuffer(
    input [3:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output EMPTY,
    output FULL,
    output [3:0] dataOut
);

// Stack memory to store data
reg [3:0] stack_mem [0:3];

// Stack pointer to track current position
reg [1:0] SP;

// Initialize flags
assign EMPTY = (SP == 4);
assign FULL = (SP == 0);

// Combinational logic for output
reg [3:0] temp_dataOut;
assign dataOut = temp_dataOut;

// Sequential logic for the stack operations
always @(posedge Clk) begin
    if (Rst) begin
        // Reset the stack and stack pointer
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
        SP <= 4;
        temp_dataOut <= 4'b0;
    end else if (EN) begin
        if (!RW &&!FULL) begin
            // Push data onto the stack
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1;
        end else if (RW &&!EMPTY) begin
            // Pop data from the stack
            temp_dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'b0;
            SP <= SP + 1;
        end
    end
end

endmodule
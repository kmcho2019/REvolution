module LIFObuffer(
    input [3:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [3:0] dataOut
);

// Stack memory to store data
reg [3:0] stack_mem [0:3];

// Stack pointer to track current position
reg [1:0] SP;

// Initialize flags
always @(posedge Clk) begin
    if (Rst) begin
        // Reset the stack and stack pointer
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
        SP <= 3; // Initialize SP to indicate an empty buffer
        EMPTY <= 1'b1;
        FULL <= 1'b0;
        dataOut <= 4'b0;
    end else if (EN) begin
        if (!RW && !FULL) begin
            // Push data onto the stack
            stack_mem[SP] <= dataIn;
            SP <= SP - 1;
            EMPTY <= 1'b0;
            FULL <= (SP == 0) ? 1'b1 : 1'b0;
        end else if (RW && !EMPTY) begin
            // Pop data from the stack
            dataOut <= stack_mem[SP + 1]; // Assign the popped data to dataOut
            stack_mem[SP + 1] <= 4'b0; // Clear the stack location
            SP <= SP + 1;
            EMPTY <= (SP == 3) ? 1'b1 : 1'b0;
            FULL <= 1'b0;
        end else begin
            dataOut <= 4'b0; // Reset dataOut if no valid operation occurs
        end
    end
end

endmodule
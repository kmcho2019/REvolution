module LIFObuffer(
    input logic [3:0] dataIn,
    input logic RW,
    input logic EN,
    input logic Rst,
    input logic Clk,
    output logic EMPTY,
    output logic FULL,
    output logic [3:0] dataOut
);

// Define the stack memory array
logic [3:0] stack_mem[0:3];

// Define the stack pointer
logic [1:0] SP;

// Initialize the stack pointer and flags
always_ff @(posedge Clk) begin
    if (Rst) begin
        // Reset the stack pointer to 4 (indicating an empty buffer)
        SP <= 2'b11;
        // Initialize all memory locations to 0
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0000;
        end
    end else if (EN) begin
        // Check if the buffer is full
        if (~RW && SP!= 2'b00) begin
            // Push data onto the stack
            stack_mem[SP - 1] <= dataIn;
            // Decrement the stack pointer
            SP <= SP - 1'b1;
        end else if (RW && SP!= 2'b11) begin
            // Pop data from the stack into dataOut
            dataOut <= stack_mem[SP];
            // Clear the corresponding stack memory
            stack_mem[SP] <= 4'b0000;
            // Increment the stack pointer
            SP <= SP + 1'b1;
        end
    end
end

// Update the EMPTY and FULL flags
always_comb begin
    // Buffer is empty if stack pointer is 4 (2'b11)
    EMPTY = (SP == 2'b11);
    // Buffer is full if stack pointer is 0 (2'b00)
    FULL = (SP == 2'b00);
end

endmodule
module LIFObuffer(
    input [3:0] dataIn,  // 4-bit input data to be pushed onto the buffer
    input RW,          // Read/Write control signal (1 for read, 0 for write)
    input EN,          // Enable signal to activate buffer operations
    input Rst,         // Active high reset signal to initialize the buffer
    input Clk,         // Clock signal for synchronous operations
    output EMPTY,      // Flag indicating whether the buffer is empty
    output FULL,       // Flag indicating whether the buffer is full
    output [3:0] dataOut // 4-bit output data retrieved from the buffer
);

// Define the size of the stack
parameter STACK_SIZE = 4;

// Define the stack memory array
reg [3:0] stack_mem [STACK_SIZE-1:0];

// Define the stack pointer
reg [1:0] SP;

// Initialize the buffer
initial begin
    for (int i = 0; i < STACK_SIZE; i++) begin
        stack_mem[i] = 4'b0000; // Initialize all memory locations to 0
    end
    SP = STACK_SIZE; // Initialize the stack pointer to indicate an empty buffer
end

// Handle the rising edge of the clock
always @(posedge Clk) begin
    if (Rst) begin
        // If the reset signal is high, clear the stack and reset the stack pointer
        for (int i = 0; i < STACK_SIZE; i++) begin
            stack_mem[i] = 4'b0000;
        end
        SP = STACK_SIZE;
    end else if (EN) begin
        // If the enable signal is high and the reset signal is low, process data
        if (RW == 1'b0 && SP > 0) begin
            // If it's a write operation and the buffer is not full, push data onto the stack
            stack_mem[SP-1] = dataIn;
            SP = SP - 1;
        end else if (RW == 1'b1 && SP < STACK_SIZE) begin
            // If it's a read operation and the buffer is not empty, pop data from the stack
            dataOut = stack_mem[SP];
            stack_mem[SP] = 4'b0000; // Clear the popped memory location
            SP = SP + 1;
        end
    end
end

// Update flags based on the stack pointer status
assign EMPTY = (SP == STACK_SIZE) ? 1'b1 : 1'b0;
assign FULL = (SP == 0) ? 1'b1 : 1'b0;

// Assign the output data if the buffer is not empty
always @(posedge Clk) begin
    if (SP < STACK_SIZE) begin
        dataOut = stack_mem[SP-1];
    end else begin
        dataOut = 4'b0000; // If the buffer is empty, output 0
    end
end

endmodule
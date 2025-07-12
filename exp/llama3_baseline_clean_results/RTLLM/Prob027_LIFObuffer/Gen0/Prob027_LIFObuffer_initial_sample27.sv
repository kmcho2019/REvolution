module LIFObuffer(
    input [3:0] dataIn, // 4-bit input data to be pushed onto the buffer
    input RW, // Read/Write control signal (1 for read, 0 for write)
    input EN, // Enable signal to activate buffer operations
    input Rst, // Active high reset signal to initialize the buffer
    input Clk, // Clock signal for synchronous operations
    output EMPTY, // Flag indicating whether the buffer is empty
    output FULL, // Flag indicating whether the buffer is full
    output [3:0] dataOut // 4-bit output data retrieved from the buffer
);

reg [3:0] stack_mem[0:3]; // Stack memory to store 4-bit data
reg [1:0] SP; // Stack pointer to track the current position
reg [3:0] dataOut_reg; // Output data register

// Initialize flags and output data
assign EMPTY = (SP == 4);
assign FULL = (SP == 0);
assign dataOut = dataOut_reg;

always @(posedge Clk) begin
    if (Rst) begin // Active high reset
        // Clear the stack, reset the stack pointer, and initialize memory locations to 0
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
        SP <= 2'd4; // Initialize SP to 4 (empty buffer)
        dataOut_reg <= 4'b0; // Reset output data
    end else if (EN) begin // Enable buffer operations
        if (~RW && (SP > 0)) begin // Write operation (push data onto the stack)
            stack_mem[SP - 1] <= dataIn; // Push data onto the stack
            SP <= SP - 1; // Decrement the stack pointer
        end else if (RW && (SP < 4)) begin // Read operation (pop data from the stack)
            dataOut_reg <= stack_mem[SP]; // Pop data from the stack
            stack_mem[SP] <= 4'b0; // Clear the popped memory location
            SP <= SP + 1; // Increment the stack pointer
        end
    end
end

endmodule
module LIFObuffer(
    input [3:0] dataIn,  // 4-bit input data to be pushed onto the buffer
    input RW,           // Read/Write control signal (1 for read, 0 for write)
    input EN,           // Enable signal to activate buffer operations
    input Rst,          // Active high reset signal to initialize the buffer
    input Clk,          // Clock signal for synchronous operations
    output EMPTY,       // Flag indicating whether the buffer is empty
    output FULL,        // Flag indicating whether the buffer is full
    output [3:0] dataOut // 4-bit output data retrieved from the buffer
);

reg [3:0] stack_mem [0:3]; // Stack memory array
reg [1:0] SP;             // Stack pointer
reg [3:0] dataOut_reg;    // Output data register

always @(posedge Clk) begin
    if (EN) begin
        if (Rst) begin
            // Reset the stack and stack pointer
            for (int i = 0; i < 4; i++) begin
                stack_mem[i] <= 4'b0;
            end
            SP <= 2'd4; // Set stack pointer to 4 (empty buffer)
        end else begin
            // Check if buffer is full or empty and perform operation
            if (RW == 0 && SP != 0) begin
                // Write operation: push data onto the stack
                stack_mem[SP - 1] <= dataIn;
                SP <= SP - 1;
            end else if (RW == 1 && SP != 4) begin
                // Read operation: pop data from the stack
                dataOut_reg <= stack_mem[SP];
                stack_mem[SP] <= 4'b0; // Clear the popped memory location
                SP <= SP + 1;
            end
        end
    end
end

assign dataOut = dataOut_reg; // Assign output data

assign EMPTY = (SP == 4); // Assign EMPTY flag
assign FULL = (SP == 0);  // Assign FULL flag

endmodule
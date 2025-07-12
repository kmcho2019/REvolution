module LIFObuffer(
    input [3:0] dataIn,  // 4-bit input data to be pushed onto the buffer
    input RW,          // Read/Write control signal (1 for read, 0 for write)
    input EN,          // Enable signal to activate buffer operations
    input Rst,         // Active high reset signal to initialize the buffer
    input Clk,         // Clock signal for synchronous operations
    output EMPTY,      // Flag indicating whether the buffer is empty
    output FULL,       // Flag indicating whether the buffer is full
    output [3:0] dataOut  // 4-bit output data retrieved from the buffer
);

reg [3:0] stack_mem[0:3];  // Stack memory array to store the data
reg [1:0] SP;            // Stack pointer to track the current position in the stack
reg [3:0] temp_data;     // Temporary data storage for read operation

always @(posedge Clk) begin
    if (EN) begin
        if (Rst) begin
            // Reset the buffer
            for (int i = 0; i < 4; i++) begin
                stack_mem[i] <= 4'b0;  // Initialize all memory locations to 0
            end
            SP <= 2'b100;  // Set the stack pointer to 4 (indicating an empty buffer)
        end else begin
            // Perform the desired operation based on the RW signal
            if (~RW && SP < 2'b100) begin
                // Push data onto the stack
                stack_mem[SP] <= dataIn;
                SP <= SP - 1'b1;
            end else if (RW && SP < 2'b100) begin
                // Pop data from the stack
                temp_data <= stack_mem[SP + 1'b1];
                stack_mem[SP + 1'b1] <= 4'b0;  // Clear the corresponding stack memory
                SP <= SP + 1'b1;
            end
        end
    end
end

assign dataOut = (RW && SP < 2'b100) ? temp_data : 4'b0;  // Assign the popped data to dataOut

assign EMPTY = (SP == 2'b100) ? 1'b1 : 1'b0;  // Update the EMPTY flag
assign FULL = (SP == 2'b0) ? 1'b1 : 1'b0;     // Update the FULL flag

endmodule
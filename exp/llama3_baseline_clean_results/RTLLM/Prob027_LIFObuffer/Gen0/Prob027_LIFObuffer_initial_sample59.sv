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

reg [3:0] stack_mem [3:0]; // Stack memory array
reg [1:0] SP; // Stack pointer
reg [3:0] dataOut_reg; // Output data register

assign EMPTY = (SP == 4); // Buffer is empty when SP is 4
assign FULL = (SP == 0); // Buffer is full when SP is 0

always @(posedge Clk) begin
    if (Rst) begin // Reset the buffer
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0; // Initialize memory locations to 0
        end
        SP <= 4; // Set stack pointer to 4 (empty buffer)
        dataOut_reg <= 4'd0; // Initialize output data to 0
    end else if (EN) begin // Perform buffer operations
        if (!RW &&!FULL) begin // Push data onto the stack (write operation)
            stack_mem[SP - 1] <= dataIn; // Store data in the stack
            SP <= SP - 1; // Decrement stack pointer
        end else if (RW &&!EMPTY) begin // Pop data from the stack (read operation)
            dataOut_reg <= stack_mem[SP]; // Retrieve data from the stack
            stack_mem[SP] <= 4'd0; // Clear the corresponding stack memory
            SP <= SP + 1; // Increment stack pointer
        end
    end
end

assign dataOut = dataOut_reg; // Assign output data

endmodule
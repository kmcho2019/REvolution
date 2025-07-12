module LIFObuffer(
    input [3:0] dataIn, // 4-bit input data
    input RW, // Read/Write control signal (1 for read, 0 for write)
    input EN, // Enable signal to activate buffer operations
    input Rst, // Active high reset signal
    input Clk, // Clock signal for synchronous operations
    output EMPTY, // Flag indicating whether the buffer is empty
    output FULL, // Flag indicating whether the buffer is full
    output [3:0] dataOut // 4-bit output data retrieved from the buffer
);

reg [3:0] stack_mem [0:3]; // Stack memory array
reg [1:0] SP; // Stack pointer
reg [3:0] temp_data; // Temporary data for pop operation

assign EMPTY = (SP == 4); // Buffer is empty when SP is 4
assign FULL = (SP == 0); // Buffer is full when SP is 0

always @(posedge Clk) begin
    if (Rst) begin // Active high reset
        SP <= 4; // Initialize stack pointer to indicate an empty buffer
        for (int i = 0; i < 4; i++) begin // Clear stack memory
            stack_mem[i] <= 4'd0;
        end
    end else if (EN) begin // Enable signal is high
        if (!RW &&!FULL) begin // Write operation and buffer is not full
            stack_mem[SP - 1] <= dataIn; // Push data onto the stack
            SP <= SP - 1; // Decrement stack pointer
        end else if (RW &&!EMPTY) begin // Read operation and buffer is not empty
            temp_data <= stack_mem[SP]; // Retrieve data from the stack
            stack_mem[SP] <= 4'd0; // Clear the corresponding stack memory
            SP <= SP + 1; // Increment stack pointer
        end
    end
end

always @(posedge Clk) begin
    if (RW &&!EMPTY) begin
        dataOut <= temp_data; // Output the popped data
    end else begin
        dataOut <= 4'd0; // Default output when not popping data
    end
end

endmodule
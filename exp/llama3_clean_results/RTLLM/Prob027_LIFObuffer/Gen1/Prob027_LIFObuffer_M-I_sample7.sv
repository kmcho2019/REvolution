module LIFObuffer(
    input [3:0] dataIn,  // 4-bit input data to be pushed onto the buffer
    input RW,            // Read/Write control signal (1 for read, 0 for write)
    input EN,            // Enable signal to activate buffer operations
    input Rst,           // Active high reset signal to initialize the buffer
    input Clk,           // Clock signal for synchronous operations
    output reg EMPTY,    // Flag indicating whether the buffer is empty
    output reg FULL,     // Flag indicating whether the buffer is full
    output reg [3:0] dataOut // 4-bit output data retrieved from the buffer
);

reg [3:0] stack_mem[3:0]; // Stack memory array
reg [1:0] SP;             // Stack pointer

always @(posedge Clk) begin
    if (Rst) begin
        // Reset: Clear stack, set SP to 4 (indicating empty), and initialize memory to 0
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0;
        end
        SP <= 2'd3; // Corrected to indicate an empty buffer
        EMPTY <= 1'b1;
        FULL <= 1'b0;
        dataOut <= 4'd0; // Initialize dataOut to avoid undefined values
    end else if (EN) begin
        // Check if buffer is full or empty and process data accordingly
        if (~RW && (SP != 2'd0)) begin
            // Write operation: Push data onto the stack and decrement SP
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1'b1;
        end else if (RW && (SP != 2'd3)) begin
            // Read operation: Pop data from the stack, clear memory, and increment SP
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'd0;
            SP <= SP + 1'b1;
        end
        // Update EMPTY and FULL flags based on SP
        EMPTY <= (SP == 2'd3);
        FULL <= (SP == 2'd0);
    end
end

endmodule
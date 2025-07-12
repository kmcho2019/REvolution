module LIFObuffer(
    input [3:0] dataIn, // 4-bit input data
    input RW,          // Read/Write control signal
    input EN,          // Enable signal
    input Rst,         // Active high reset signal
    input Clk,         // Clock signal
    output EMPTY,      // Flag indicating an empty buffer
    output FULL,       // Flag indicating a full buffer
    output [3:0] dataOut // 4-bit output data
);

reg [3:0] stack_mem [0:3]; // Stack memory to hold up to 4 entries
reg [1:0] SP;             // Stack pointer (2 bits to represent 0-3)

// Initialize EMPTY and FULL flags based on the stack pointer
assign EMPTY = (SP == 4'd4);
assign FULL = (SP == 1'b0);

// Synchronous reset and buffer operations
always @(posedge Clk) begin
    if (Rst) begin // Active high reset
        SP <= 4'd4; // Set stack pointer to indicate an empty buffer
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0; // Initialize all stack memory locations to 0
        end
    end else if (EN) begin // Enable signal is high
        if (~RW && ~FULL) begin // Write operation and buffer is not full
            stack_mem[SP] <= dataIn; // Push data onto the stack
            SP <= SP - 1; // Decrement stack pointer
        end else if (RW && ~EMPTY) begin // Read operation and buffer is not empty
            dataOut <= stack_mem[SP + 1]; // Pop data from the stack into dataOut
            stack_mem[SP + 1] <= 4'd0; // Clear the popped stack memory location
            SP <= SP + 1; // Increment stack pointer
        end
    end
end

endmodule
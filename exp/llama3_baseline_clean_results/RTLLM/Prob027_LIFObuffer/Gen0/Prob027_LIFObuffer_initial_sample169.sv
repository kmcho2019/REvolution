module LIFObuffer(
    input   logic           Clk,    // Clock signal
    input   logic           Rst,    // Active high reset signal
    input   logic           EN,     // Enable signal
    input   logic           RW,     // Read/Write control signal
    input   logic [3:0]      dataIn, // 4-bit input data
    output  logic           EMPTY,  // Flag indicating whether the buffer is empty
    output  logic           FULL,   // Flag indicating whether the buffer is full
    output  logic [3:0]      dataOut // 4-bit output data
);

// Internal signals and variables
logic [3:0] stack_mem [0:3]; // Stack memory array
logic [1:0] SP;            // Stack pointer (2 bits for 0-3 range)

// Initialize flags and stack pointer
always @(posedge Clk) begin
    if (Rst) begin
        // On reset, clear stack, set SP to 4 (empty), and initialize memory to 0
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
        SP <= 2'b11; // 4 in decimal, indicating an empty buffer
        EMPTY <= 1'b1;
        FULL <= 1'b0;
    end else if (EN) begin
        // Handle push and pop operations based on RW signal
        if (!RW && (SP != 2'b00)) begin // Write operation and buffer is not full
            stack_mem[SP] <= dataIn; // Push data onto the stack
            SP <= SP - 1'b1; // Decrement stack pointer
        end else if (RW && (SP != 2'b11)) begin // Read operation and buffer is not empty
            dataOut <= stack_mem[SP + 1'b1]; // Pop data from the stack
            stack_mem[SP + 1'b1] <= 4'b0; // Clear the popped memory location
            SP <= SP + 1'b1; // Increment stack pointer
        end
    end

    // Update EMPTY and FULL flags
    if (SP == 2'b11) begin
        EMPTY <= 1'b1;
        FULL <= 1'b0;
    end else if (SP == 2'b00) begin
        EMPTY <= 1'b0;
        FULL <= 1'b1;
    end else begin
        EMPTY <= 1'b0;
        FULL <= 1'b0;
    end
end

endmodule
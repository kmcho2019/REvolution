module LIFObuffer (
    input logic Clk, // Clock signal
    input logic Rst, // Active high reset signal
    input logic EN,  // Enable signal for buffer operations
    input logic RW,  // Read/Write control signal (1 for read, 0 for write)
    input logic [3:0] dataIn, // 4-bit input data to be pushed onto the buffer
    output logic EMPTY, // Flag indicating whether the buffer is empty
    output logic FULL,  // Flag indicating whether the buffer is full
    output logic [3:0] dataOut // 4-bit output data retrieved from the buffer
);

logic [3:0] stack_mem [0:3]; // 4x4-bit stack memory array
logic [1:0] SP; // Stack pointer to track the current position

// Initialize flags and data output
assign EMPTY = (SP == 4'd4);
assign FULL = (SP == 4'd0);
assign dataOut = (RW && !EMPTY) ? stack_mem[SP - 1] : 4'd0;

// Sequential logic for the LIFObuffer
always_ff @(posedge Clk) begin
    if (Rst) begin // Active high reset
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0; // Initialize stack memory to 0
        end
        SP <= 4'd4; // Reset stack pointer to indicate an empty buffer
    end else if (EN) begin // Enable buffer operations
        if (!RW && !FULL) begin // Push operation (write)
            stack_mem[SP - 1] <= dataIn; // Push data onto the stack
            SP <= SP - 1; // Decrement stack pointer
        end else if (RW && !EMPTY) begin // Pop operation (read)
            stack_mem[SP] <= 4'd0; // Clear the popped data from the stack
            SP <= SP + 1; // Increment stack pointer
        end
    end
end

endmodule
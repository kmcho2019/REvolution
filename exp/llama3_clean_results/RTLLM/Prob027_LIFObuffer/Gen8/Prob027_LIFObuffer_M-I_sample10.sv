module LIFObuffer #(
    parameter BUFFER_SIZE = 4,
    parameter DATA_WIDTH = 4
) (
    input [DATA_WIDTH-1:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [DATA_WIDTH-1:0] dataOut
);

reg [DATA_WIDTH-1:0] stack_mem [0:BUFFER_SIZE-1]; // Stack memory array
reg [BUFFER_SIZE-1:0] SP; // Stack pointer

// Sequential logic for stack pointer, stack memory, and flags
always @(posedge Clk) begin
    if (Rst) begin // Active high reset
        SP <= BUFFER_SIZE; // Initialize stack pointer to BUFFER_SIZE (empty buffer)
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            stack_mem[i] <= {DATA_WIDTH{1'b0}}; // Initialize stack memory to 0
        end
        dataOut <= {DATA_WIDTH{1'b0}};
        EMPTY <= 1'b1; // Buffer is empty after reset
        FULL <= 1'b0; // Buffer is not full after reset
    end else if (EN) begin // Enable signal is high
        if (!RW && !FULL) begin // Push operation
            stack_mem[SP-1] <= dataIn; // Push data onto stack
            SP <= SP - 1; // Decrement stack pointer
            EMPTY <= 1'b0; // Buffer is not empty after push
            FULL <= (SP == 0); // Update FULL flag
        end else if (RW && !EMPTY) begin // Pop operation
            dataOut <= stack_mem[SP]; // Pop data from stack
            stack_mem[SP] <= {DATA_WIDTH{1'b0}}; // Clear popped data
            SP <= SP + 1; // Increment stack pointer
            FULL <= 1'b0; // Buffer is not full after pop
            EMPTY <= (SP == BUFFER_SIZE); // Update EMPTY flag
        end
    end
end

endmodule
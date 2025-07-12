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
reg [1:0] SP; // Stack pointer (optimized to 2 bits for a 4-entry buffer)

// Combinational logic for EMPTY and FULL flags
assign EMPTY = (SP == 0); // Buffer is empty when SP is 0
assign FULL = (SP == BUFFER_SIZE-1); // Buffer is full when SP is at the last index

// Sequential logic for stack pointer and stack memory
always @(posedge Clk) begin
    if (Rst) begin // Active high reset
        SP <= 0; // Initialize stack pointer to 0 (empty buffer)
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            stack_mem[i] <= {DATA_WIDTH{1'b0}}; // Initialize stack memory to 0
        end
        dataOut <= {DATA_WIDTH{1'b0}};
    end else if (EN) begin // Enable signal is high
        if (!RW && !FULL) begin // Push operation
            stack_mem[SP] <= dataIn; // Push data onto stack
            SP <= SP + 1; // Increment stack pointer
        end else if (RW && !EMPTY) begin // Pop operation
            dataOut <= stack_mem[SP-1]; // Pop data from stack
            stack_mem[SP-1] <= {DATA_WIDTH{1'b0}}; // Clear popped data
            SP <= SP - 1; // Decrement stack pointer
        end
    end
end

endmodule
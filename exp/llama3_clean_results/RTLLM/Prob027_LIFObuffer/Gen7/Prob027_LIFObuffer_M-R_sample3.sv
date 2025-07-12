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

reg [DATA_WIDTH-1:0] stack_mem [0:BUFFER_SIZE-1]; // Stack memory
reg [2:0] SP; // Stack pointer

// Assignments for EMPTY and FULL flags
always @(*) begin
    if (SP == BUFFER_SIZE) begin
        EMPTY = 1'b0;
        FULL = 1'b1;
    end else if (SP == 0) begin
        EMPTY = 1'b1;
        FULL = 1'b0;
    end else begin
        EMPTY = 1'b0;
        FULL = 1'b0;
    end
end

// Sequential logic for stack operations
always @(posedge Clk) begin
    if (Rst) begin // Active high reset
        SP <= BUFFER_SIZE; // Initialize stack pointer to indicate empty stack
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            stack_mem[i] <= {DATA_WIDTH{1'b0}}; // Initialize stack memory to 0
        end
        dataOut <= {DATA_WIDTH{1'b0}};
    end else if (EN) begin // Enable signal is high
        if (!RW && !FULL) begin // Push operation
            stack_mem[SP - 1] <= dataIn; // Push data onto stack
            SP <= SP - 1; // Decrement stack pointer
        end else if (RW && !EMPTY) begin // Pop operation
            dataOut <= stack_mem[SP]; // Pop data from stack
            stack_mem[SP] <= {DATA_WIDTH{1'b0}}; // Clear popped data
            SP <= SP + 1; // Increment stack pointer
        end
    end
end

endmodule
module LIFObuffer #(
    parameter BUFFER_SIZE = 4,
    parameter DATA_WIDTH = 4
) (
    input [DATA_WIDTH-1:0] dataIn,
    input RW, // 1 for read, 0 for write
    input EN, // Enable signal
    input Rst, // Active high reset
    input Clk, // Clock signal
    output reg EMPTY, // Flag indicating the buffer is empty
    output reg FULL, // Flag indicating the buffer is full
    output reg [DATA_WIDTH-1:0] dataOut // Output data
);

reg [DATA_WIDTH-1:0] stack_mem [0:BUFFER_SIZE-1]; // Stack memory array
reg [BUFFER_SIZE-1:0] SP; // Stack pointer

always @(posedge Clk) begin
    if (Rst) begin // Active high reset
        SP <= BUFFER_SIZE-1; // Initialize stack pointer to BUFFER_SIZE-1 (empty buffer)
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            stack_mem[i] <= {DATA_WIDTH{1'b0}}; // Initialize stack memory to 0
        end
        dataOut <= {DATA_WIDTH{1'b0}}; // Initialize dataOut to 0
        EMPTY <= 1'b1; // Initialize EMPTY flag
        FULL <= 1'b0; // Initialize FULL flag
    end else if (EN) begin // Enable signal is high
        if (RW && (SP < BUFFER_SIZE-1)) begin // Read operation and buffer is not empty
            dataOut <= stack_mem[SP]; // Pop data from stack
            stack_mem[SP] <= {DATA_WIDTH{1'b0}}; // Clear popped data
            SP <= SP + 1; // Increment stack pointer
        end else if (!RW && (SP > 0)) begin // Write operation and buffer is not full
            stack_mem[SP-1] <= dataIn; // Push data onto stack
            SP <= SP - 1; // Decrement stack pointer
        end
        // Update EMPTY and FULL flags
        EMPTY <= (SP == BUFFER_SIZE-1); // Buffer is empty when SP is at BUFFER_SIZE-1
        FULL <= (SP == 0); // Buffer is full when SP is at 0
    end
end

endmodule
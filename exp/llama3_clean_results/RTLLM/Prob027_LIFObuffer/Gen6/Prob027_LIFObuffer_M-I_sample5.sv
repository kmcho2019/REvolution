module LIFObuffer #(
    parameter BUFFER_SIZE = 4,
    parameter DATA_WIDTH = 4
) (
    input [DATA_WIDTH-1:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output reg EMPTY, // Declare EMPTY as a reg
    output reg FULL, // Declare FULL as a reg
    output reg [DATA_WIDTH-1:0] dataOut // Declare dataOut as a reg
);

reg [DATA_WIDTH-1:0] stack_mem [0:BUFFER_SIZE-1]; // Stack memory array
reg [BUFFER_SIZE:0] SP; // Stack pointer, adjusted for 0 to BUFFER_SIZE range

always @(posedge Clk) begin
    if (Rst) begin // Active high reset
        SP <= BUFFER_SIZE; // Initialize stack pointer to BUFFER_SIZE (empty buffer)
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            stack_mem[i] <= {DATA_WIDTH{1'b0}}; // Initialize stack memory to 0
        end
        dataOut <= {DATA_WIDTH{1'b0}}; // Initialize dataOut to 0
        EMPTY <= 1'b1; // Initialize EMPTY flag
        FULL <= 1'b0; // Initialize FULL flag
    end else if (EN) begin // Enable signal is high
        if (RW && (SP < BUFFER_SIZE)) begin // RW is high, buffer is not empty
            dataOut <= stack_mem[SP]; // Pop data from stack
            stack_mem[SP] <= {DATA_WIDTH{1'b0}}; // Clear popped data
            SP <= SP + 1; // Increment stack pointer
        end else if (!RW && (SP > 0)) begin // RW is low, buffer is not full
            stack_mem[SP-1] <= dataIn; // Push data onto stack
            SP <= SP - 1; // Decrement stack pointer
        end
        // Update EMPTY and FULL flags
        EMPTY <= (SP == BUFFER_SIZE);
        FULL <= (SP == 0);
    end
end

endmodule
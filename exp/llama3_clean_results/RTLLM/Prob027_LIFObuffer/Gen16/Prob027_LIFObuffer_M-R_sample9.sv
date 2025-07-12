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
reg [2:0] SP; // Stack pointer
reg [2:0] next_SP; // Next stack pointer value
reg [DATA_WIDTH-1:0] next_dataOut; // Next dataOut value

// Combinational logic for EMPTY and FULL flags
assign EMPTY = (SP == BUFFER_SIZE); // Buffer is empty when SP is equal to BUFFER_SIZE
assign FULL = (SP == 0); // Buffer is full when SP is 0

// Combinational logic for next state (stack pointer and dataOut)
always @(*) begin
    next_SP = SP;
    next_dataOut = dataOut;
    
    if (Rst) begin // Active high reset
        next_SP = BUFFER_SIZE; // Initialize stack pointer to BUFFER_SIZE (empty buffer)
        next_dataOut = {DATA_WIDTH{1'b0}};
    end else if (EN) begin // Enable signal is high
        if (!RW && SP > 0 && !FULL) begin // Push operation
            next_SP = SP - 1; // Decrement stack pointer
        end else if (RW && SP < BUFFER_SIZE && !EMPTY) begin // Pop operation
            next_dataOut = stack_mem[SP]; // Pop data from stack
            next_SP = SP + 1; // Increment stack pointer
        end
    end
end

// Sequential logic for stack pointer and stack memory
always @(posedge Clk) begin
    if (Rst) begin // Active high reset
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            stack_mem[i] <= {DATA_WIDTH{1'b0}}; // Initialize stack memory to 0
        end
    end else if (EN) begin // Enable signal is high
        if (!RW && SP > 0 && !FULL) begin // Push operation
            stack_mem[SP-1] <= dataIn; // Push data onto stack
        end else if (RW && SP < BUFFER_SIZE && !EMPTY) begin // Pop operation
            stack_mem[SP] <= {DATA_WIDTH{1'b0}}; // Clear popped data
        end
        SP <= next_SP;
        dataOut <= next_dataOut;
    end
end

endmodule
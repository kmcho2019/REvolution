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
reg [$clog2(BUFFER_SIZE):0] SP; // Stack pointer, using $clog2 for optimal bit width
reg [DATA_WIDTH-1:0] next_dataOut; // Next data out
reg [$clog2(BUFFER_SIZE):0] next_SP; // Next stack pointer

// Combinational logic for next state
always @(*) begin
    if (Rst) begin
        next_SP = BUFFER_SIZE; // Initialize stack pointer to BUFFER_SIZE (empty buffer)
        next_dataOut = {DATA_WIDTH{1'b0}};
    end else if (EN) begin
        if (!RW && SP > 0) begin // Push operation
            next_SP = SP - 1; // Decrement stack pointer
            next_dataOut = {DATA_WIDTH{1'b0}};
        end else if (RW && SP < BUFFER_SIZE) begin // Pop operation
            next_dataOut = stack_mem[SP]; // Pop data from stack
            next_SP = SP + 1; // Increment stack pointer
        end else begin
            next_SP = SP;
            next_dataOut = dataOut;
        end
    end else begin
        next_SP = SP;
        next_dataOut = dataOut;
    end
end

// Sequential logic for stack operations
always @(posedge Clk) begin
    if (Rst) begin
        SP <= BUFFER_SIZE; // Initialize stack pointer to BUFFER_SIZE (empty buffer)
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            stack_mem[i] <= {DATA_WIDTH{1'b0}}; // Initialize stack memory to 0
        end
        dataOut <= {DATA_WIDTH{1'b0}};
    end else if (EN) begin
        if (!RW && SP > 0) begin // Push operation
            stack_mem[SP-1] <= dataIn; // Push data onto stack
        end else if (RW && SP < BUFFER_SIZE) begin // Pop operation
            stack_mem[SP] <= {DATA_WIDTH{1'b0}}; // Clear popped data
        end
        SP <= next_SP;
        dataOut <= next_dataOut;
    end
end

// Simplified logic for EMPTY and FULL flags
assign EMPTY = (SP == BUFFER_SIZE);
assign FULL = (SP == 0);

endmodule
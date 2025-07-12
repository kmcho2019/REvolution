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
reg [BUFFER_SIZE-1:0] SP; // Stack pointer
reg [1:0] state; // State machine state

// State machine states
localparam IDLE = 2'b00;
localparam PUSH = 2'b01;
localparam POP = 2'b10;

// Combinational logic for EMPTY and FULL flags
assign EMPTY = (SP == BUFFER_SIZE); // Buffer is empty when SP is equal to BUFFER_SIZE
assign FULL = (SP == 0); // Buffer is full when SP is 0

// Sequential logic for state machine and stack pointer
always @(posedge Clk) begin
    if (Rst) begin // Active high reset
        state <= IDLE; // Reset state to IDLE
        SP <= BUFFER_SIZE; // Initialize stack pointer to BUFFER_SIZE (empty buffer)
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            stack_mem[i] <= {DATA_WIDTH{1'b0}}; // Initialize stack memory to 0
        end
    end else if (EN) begin // Enable signal is high
        case (state)
            IDLE: begin
                if (!RW && !FULL) begin // Push operation
                    state <= PUSH;
                end else if (RW && !EMPTY) begin // Pop operation
                    state <= POP;
                end
            end
            PUSH: begin
                stack_mem[SP-1] <= dataIn; // Push data onto stack
                SP <= SP - 1; // Decrement stack pointer
                state <= IDLE;
            end
            POP: begin
                dataOut <= stack_mem[SP]; // Pop data from stack
                stack_mem[SP] <= {DATA_WIDTH{1'b0}}; // Clear popped data
                SP <= SP + 1; // Increment stack pointer
                state <= IDLE;
            end
        endcase
    end
end

endmodule
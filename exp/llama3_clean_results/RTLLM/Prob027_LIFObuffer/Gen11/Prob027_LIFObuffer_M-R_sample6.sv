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

// Combinational logic for EMPTY and FULL flags
assign EMPTY = (SP == BUFFER_SIZE); // Buffer is empty when SP is equal to BUFFER_SIZE
assign FULL = (SP == 0); // Buffer is full when SP is 0

// State machine states
enum logic [1:0] {
    IDLE,
    PUSH,
    POP
} state, next_state;

// Sequential logic for state machine and stack pointer
always @(posedge Clk) begin
    if (Rst) begin // Active high reset
        state <= IDLE;
        SP <= BUFFER_SIZE; // Initialize stack pointer to BUFFER_SIZE (empty buffer)
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            stack_mem[i] <= {DATA_WIDTH{1'b0}}; // Initialize stack memory to 0
        end
        dataOut <= {DATA_WIDTH{1'b0}};
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (EN &&!RW &&!FULL) begin // Push operation
                    next_state <= PUSH;
                end else if (EN && RW &&!EMPTY) begin // Pop operation
                    next_state <= POP;
                end else begin
                    next_state <= IDLE;
                end
            end
            PUSH: begin
                stack_mem[SP-1] <= dataIn; // Push data onto stack
                SP <= SP - 1; // Decrement stack pointer
                next_state <= IDLE;
            end
            POP: begin
                dataOut <= stack_mem[SP]; // Pop data from stack
                stack_mem[SP] <= {DATA_WIDTH{1'b0}}; // Clear popped data
                SP <= SP + 1; // Increment stack pointer
                next_state <= IDLE;
            end
            default: next_state <= IDLE;
        endcase
    end
end

endmodule
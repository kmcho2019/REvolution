module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,       // Active-high synchronous reset
    input  wire        EN,        // Enable signal
    input  wire        RW,        // 0 = write (push), 1 = read (pop)
    input  wire [3:0]  dataIn,
    output reg  [3:0]  dataOut,
    output wire        EMPTY,
    output wire        FULL
);

    // Stack memory: 4 entries, 4-bit each
    reg [3:0] stack_mem [3:0];

    // Stack Pointer (SP):
    // Counts down from 4 (empty) to 0 (full)
    // push: SP decreases by 1, new data written at SP-1
    // pop:  dataOut loaded from SP, then SP increases by 1
    reg [2:0] SP; // Range 0..4, 4 means empty

    // Operation signals
    wire push_op = EN && (RW == 1'b0) && (SP != 3'd0); // push if not full
    wire pop_op  = EN && (RW == 1'b1) && (SP != 3'd4); // pop if not empty
    wire valid_op = push_op || pop_op;

    // Compute next stack pointer
    wire [2:0] next_SP = push_op ? (SP - 3'd1) :
                         pop_op  ? (SP + 3'd1) :
                                   SP;

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset: empty stack, clear dataOut and stack_mem
            SP <= 3'd4;
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'd0;
        end else if (valid_op) begin
            SP <= next_SP;

            if (push_op) begin
                // Push: write dataIn at SP-1 (new top)
                stack_mem[SP - 3'd1] <= dataIn;
                // dataOut not changed on push
            end else if (pop_op) begin
                // Pop: read dataOut from stack_mem[SP]
                dataOut <= stack_mem[SP];
                // Do not clear stack_mem[SP] to save power
            end
            // If valid_op but neither push nor pop (should not happen), no action
        end
        // If no valid_op, hold all registers
    end

    // Flags combinationally derived from SP
    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

endmodule
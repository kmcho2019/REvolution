module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,       // Active-high synchronous reset
    input  wire        EN,        // Enable signal
    input  wire        RW,        // 0 = write (push), 1 = read (pop)
    input  wire [3:0]  dataIn,
    output wire        EMPTY,
    output wire        FULL,
    output reg  [3:0]  dataOut
);

    // Stack memory: 4 entries, 4-bit each
    reg [3:0] stack_mem [3:0];

    // Stack Pointer (SP):
    // Counts up from 0 (empty) to 4 (full).
    // push: store at SP, then increment SP
    // pop : decrement SP, then read from SP-1
    reg [2:0] SP; // 3 bits to count 0..4

    // Determine push and pop conditions
    wire push_op = EN && (RW == 1'b0) && (SP != 3'd4); // push if not full
    wire pop_op  = EN && (RW == 1'b1) && (SP != 3'd0); // pop if not empty
    wire valid_op = push_op || pop_op;

    // Next stack pointer calculations
    wire [2:0] next_SP = push_op ? (SP + 3'd1) :
                         pop_op  ? (SP - 3'd1) :
                                   SP;

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            // Synchronous reset: clear stack pointer, output and memory
            SP <= 3'd0;      // Empty stack pointer
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else if (valid_op) begin
            if (push_op) begin
                // Push dataIn onto stack at SP (current top)
                stack_mem[SP] <= dataIn;
            end
            if (pop_op) begin
                // Pop data from stack at SP - 1
                dataOut <= stack_mem[SP - 3'd1];
                // Do not clear memory to save power
            end
            // Update stack pointer after push or pop
            SP <= next_SP;
        end
        // If no valid_op, hold values to reduce toggling
    end

    // Flags derived combinationally from SP
    assign EMPTY = (SP == 3'd0);
    assign FULL  = (SP == 3'd4);

endmodule
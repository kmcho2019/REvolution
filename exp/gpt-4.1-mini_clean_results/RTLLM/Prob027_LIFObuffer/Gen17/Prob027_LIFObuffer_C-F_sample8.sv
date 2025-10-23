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
    // SP counts down from 4 (empty) to 0 (full).
    // push: SP decreases (push at SP-1)
    // pop : SP increases (pop from SP)
    reg [2:0] SP; // 3-bit pointer: values 0..4 (4 means empty)

    // Determine push and pop conditions
    wire push_op = EN && (RW == 1'b0) && (SP != 3'd0); // push if not full
    wire pop_op  = EN && (RW == 1'b1) && (SP != 3'd4); // pop if not empty
    wire valid_op = push_op || pop_op;

    // Calculate next stack pointer
    wire [2:0] next_SP = push_op ? (SP - 3'd1) :
                         pop_op  ? (SP + 3'd1) :
                                   SP;

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            // Synchronous reset: clear stack pointer, output and memory
            SP <= 3'd4;      // Empty stack pointer
            dataOut <= 4'd0;
            for (i = 0; i < 4; i = i + 1) begin
                stack_mem[i] <= 4'd0;
            end
        end else begin
            if (valid_op) begin
                SP <= next_SP;

                if (push_op) begin
                    // Push dataIn onto stack at SP-1 (new top)
                    stack_mem[SP - 3'd1] <= dataIn;
                end

                if (pop_op) begin
                    // Pop data from stack at SP
                    dataOut <= stack_mem[SP];
                    // Do not clear memory to save power
                end
            end
            // Hold values if no valid_op, reducing toggling
        end
    end

    // Flags derived combinationally from SP
    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

endmodule
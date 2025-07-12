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
    // SP counts down from 4 (empty) to 0 (full).
    // push: SP decreases (push at SP-1)
    // pop : SP increases (pop from SP)
    reg [2:0] SP; // 3-bit: values 0..4 (with 4 = empty)

    // Operation signals
    wire push_op = EN && (RW == 1'b0) && (SP != 3'd0); // push if not full
    wire pop_op  = EN && (RW == 1'b1) && (SP != 3'd4); // pop if not empty
    wire valid_op = push_op || pop_op;

    wire [2:0] next_SP = push_op ? (SP - 3'd1) :
                         pop_op  ? (SP + 3'd1) :
                                   SP;

    integer i;

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset state: empty stack, clear memory and output
            SP <= 3'd4;
            dataOut <= 4'd0;
            // Clear stack memory once on reset assertion
            for (i = 0; i < 4; i = i + 1)
                stack_mem[i] <= 4'd0;
        end else begin
            SP <= next_SP;

            // Only write stack_mem on push operation to save power
            if (push_op) begin
                // Push dataIn onto stack at SP-1 (new top)
                stack_mem[SP - 3'd1] <= dataIn;
            end

            // Update dataOut only on pop operation
            if (pop_op) begin
                dataOut <= stack_mem[SP];
            end
            // No clearing of stack_mem on pop to save power
        end
    end

    // Flags combinational from SP
    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

endmodule
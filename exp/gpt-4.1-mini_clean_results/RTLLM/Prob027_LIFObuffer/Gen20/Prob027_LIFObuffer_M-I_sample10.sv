module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst_n,     // Active-low asynchronous reset
    input  wire        EN,        // Enable signal
    input  wire        RW,        // 0 = write (push), 1 = read (pop)
    input  wire [3:0]  dataIn,
    output reg  [3:0]  dataOut,
    output wire        EMPTY,
    output wire        FULL
);

    // Parameter for stack depth
    localparam DEPTH = 4;
    localparam PTR_WIDTH = 3; // Enough to count up to DEPTH

    // Stack memory: 4 entries, 4-bit each
    reg [3:0] stack_mem [DEPTH-1:0];

    // Stack Pointer (SP):
    // Counts down from 4 (empty) to 0 (full)
    // push: SP decreases by 1, new data written at SP-1
    // pop:  dataOut loaded from SP, then SP increases by 1
    reg [PTR_WIDTH-1:0] SP;

    // Operation signals
    wire push_op = EN && (RW == 1'b0) && (SP != 3'd0); // push if not full
    wire pop_op  = EN && (RW == 1'b1) && (SP != 3'd4); // pop if not empty
    wire valid_op = push_op || pop_op;

    // Compute next stack pointer
    wire [PTR_WIDTH-1:0] next_SP = push_op ? (SP - 3'd1) :
                                   pop_op  ? (SP + 3'd1) :
                                             SP;

    // Clock gating: gated clock enables updates only when EN is asserted
    wire gated_clk = Clk & EN;

    integer i;

    // Synchronous logic with asynchronous active-low reset
    always @(posedge Clk or negedge Rst_n) begin
        if (!Rst_n) begin
            // Async reset: empty stack, reset dataOut
            SP <= 3'd4; 
            dataOut <= 4'd0;
            // Note: Do not clear stack_mem explicitly for power and area savings
        end else if (EN) begin
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
            // Otherwise hold state
        end
    end

    // Flags combinationally derived from SP
    assign EMPTY = (SP == 3'd4);
    assign FULL  = (SP == 3'd0);

endmodule
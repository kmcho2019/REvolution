module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,       // Active-high asynchronous reset
    input  wire        EN,        // Enable signal
    input  wire        RW,        // 0 = write (push), 1 = read (pop)
    input  wire [3:0]  dataIn,
    output reg  [3:0]  dataOut,
    output wire        EMPTY,
    output wire        FULL
);

    localparam DEPTH = 4;           // Stack depth
    localparam PTR_WIDTH = 3;       // Enough to represent 0..DEPTH

    // Stack memory: 4 entries, 4-bit each
    reg [3:0] stack_mem [DEPTH-1:0];

    // Stack Pointer (SP):
    // Counts down from DEPTH (empty) to 0 (full)
    // push: SP decreases by 1, new data written at SP-1
    // pop:  dataOut loaded from SP, then SP increases by 1
    reg [PTR_WIDTH-1:0] SP; // Range 0..DEPTH, DEPTH means empty

    // Operation signals
    wire push_op = EN && (RW == 1'b0) && (SP != 0);       // push if not full
    wire pop_op  = EN && (RW == 1'b1) && (SP != DEPTH);  // pop if not empty
    wire valid_op = push_op || pop_op;

    // Compute next stack pointer
    wire [PTR_WIDTH-1:0] next_SP = push_op ? (SP - 1) :
                                  pop_op  ? (SP + 1) :
                                            SP;

    // Clock gating enable: only clock registers when EN and valid operation active
    wire gated_clk_en = EN && valid_op;

    // For clock gating, using a clock enable scheme inside the always block
    // Instead of using an actual gated clock signal, use if (gated_clk_en) inside always @(posedge Clk)
    // This helps synthesis tools infer clock gating or clock enables properly

    // Asynchronous reset for SP and dataOut, no reset for stack_mem for reduced toggling
    integer i;

    always @(posedge Clk or posedge Rst) begin
        if (Rst) begin
            SP <= DEPTH;
            dataOut <= 4'd0;
            // Do NOT reset stack_mem to reduce toggling and reset latency
            // stack_mem content is irrelevant when SP=DEPTH (empty)
        end else if (gated_clk_en) begin
            SP <= next_SP;
            if (push_op) begin
                // Push: write dataIn at SP-1 (new top)
                stack_mem[SP - 1] <= dataIn;
                // dataOut not changed on push
            end else if (pop_op) begin
                // Pop: read dataOut from stack_mem[SP]
                dataOut <= stack_mem[SP];
                // Do NOT clear stack_mem[SP] to save power
            end
            // no else needed
        end
        // else hold registers to reduce toggling
    end

    // Flags combinationally derived from SP
    assign EMPTY = (SP == DEPTH);
    assign FULL  = (SP == 0);

endmodule
module TopModule (
    input  clk,
    input  reset,
    input  w,
    output reg z
);

    // One-hot state encoding
    localparam A = 6'b000001;
    localparam B = 6'b000010;
    localparam C = 6'b000100;
    localparam D = 6'b001000;
    localparam E = 6'b010000;
    localparam F = 6'b100000;

    reg [5:0] state, next_state;

    // State flip-flops with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        // Default next_state to current state (safe default)
        next_state = state;
        case (state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? F : A;
            E: next_state = w ? E : D;
            F: next_state = w ? C : D;
            default: next_state = A; // safe default on invalid state
        endcase
    end

    // Output logic: z = 1 if state is E or F, else 0
    always @(*) begin
        z = (state == E) || (state == F);
    end

endmodule
module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    localparam STATE_A = 3'b000;
    localparam STATE_B = 3'b001;
    localparam STATE_C = 3'b010;
    localparam STATE_D = 3'b011;
    localparam STATE_E = 3'b100;
    localparam STATE_F = 3'b101;

    reg [2:0] next_state;

    always @(*) begin
        case (y)
            STATE_A: next_state = w? STATE_A : STATE_B;
            STATE_B: next_state = w? STATE_D : STATE_C;
            STATE_C: next_state = w? STATE_D : STATE_E;
            STATE_D: next_state = w? STATE_A : STATE_F;
            STATE_E: next_state = w? STATE_D : STATE_E;
            STATE_F: next_state = w? STATE_D : STATE_C;
            default: next_state = STATE_A;
        endcase
    end

    assign Y1 = y[1];

    // Using Karnaugh map to optimize next-state logic
    // We can represent the next-state logic as a function of current state and input w
    // The Karnaugh map can help us identify patterns and simplify the logic
    // For example, we can see that the next-state logic for y[1] can be simplified as follows:
    // next_state[1] = (y[1] & ~w) | (~y[0] & y[2] & w) | (y[0] & ~y[2] & w)

    // However, the above simplification is not required as we are already using a case statement
    // to determine the next state, which is more efficient and easier to understand

endmodule
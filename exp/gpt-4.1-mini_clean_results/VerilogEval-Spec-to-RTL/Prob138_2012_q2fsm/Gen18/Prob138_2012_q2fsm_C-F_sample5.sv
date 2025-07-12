module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

    // State encoding (3-bit binary)
    localparam A = 3'd0,
               B = 3'd1,
               C = 3'd2,
               D = 3'd3,
               E = 3'd4,
               F = 3'd5;

    reg [2:0] state, next_state;

    wire state_change = (next_state != state);

    // Sequential logic: state register with synchronous active-high reset and enable to reduce toggling
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else if (state_change)
            state <= next_state;
    end

    // Combinational logic: next state logic using case statement for clarity and synthesis friendliness
    always @(*) begin
        case (state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? F : A;
            E: next_state = w ? E : D;
            F: next_state = w ? C : D;
            default: next_state = A; // safety fallback
        endcase
    end

    // Output logic: z asserted only in states E and F via continuous assignment for minimal power
    assign z = (state == E) | (state == F);

endmodule
module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // One-hot state encoding: only one bit high at a time
    reg [3:0] state, next_state;

    // State bits for readability
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    // Next-state logic in combinational block using case statement on current state
    always @(*) begin
        case (state)
            A: next_state = (in == 1'b0) ? A : B;
            B: next_state = (in == 1'b0) ? C : B;
            C: next_state = (in == 1'b0) ? A : D;
            D: next_state = (in == 1'b0) ? C : B;
            default: next_state = A; // Defensive default state
        endcase
    end

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output is 1 only when in state D
    assign out = state[3];

endmodule
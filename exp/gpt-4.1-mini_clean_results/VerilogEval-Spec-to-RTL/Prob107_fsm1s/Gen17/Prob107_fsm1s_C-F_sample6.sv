module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // State encoding
    localparam B = 1'b0;
    localparam A = 1'b1;

    reg state, next_state;

    // Combinational next-state logic
    always @(*) begin
        case (state)
            B: next_state = (in == 1'b0) ? A : B;
            A: next_state = (in == 1'b0) ? B : A;
            default: next_state = B; // default safe state
        endcase
    end

    // Clock enable: update state only if next_state differs from current state
    wire state_en = (next_state != state);

    // Sequential state register with synchronous active-high reset and clock enable
    always @(posedge clk) begin
        if (reset) begin
            state <= B;
        end else if (state_en) begin
            state <= next_state;
        end
    end

    // Moore FSM output logic - output depends only on current state
    assign out = (state == B);

endmodule
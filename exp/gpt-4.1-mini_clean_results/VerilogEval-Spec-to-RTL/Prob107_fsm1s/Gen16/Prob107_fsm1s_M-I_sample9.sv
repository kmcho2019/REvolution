module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // State encoding
    localparam B = 1'b0;
    localparam A = 1'b1;

    reg state;
    reg next_state;

    // Next-state combinational logic
    always @(*) begin
        case (state)
            B: next_state = (in == 1'b0) ? A : B;
            A: next_state = (in == 1'b0) ? B : A;
            default: next_state = B;
        endcase
    end

    // Clock gating enable: only update state if next_state differs from current or reset asserted
    wire state_en = reset | (state != next_state);
    wire gated_clk = clk & state_en;

    // Synchronous reset and gated clock state update
    always @(posedge gated_clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

    assign out = (state == B);

endmodule
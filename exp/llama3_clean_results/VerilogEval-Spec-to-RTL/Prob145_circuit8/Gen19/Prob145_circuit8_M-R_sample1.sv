module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg state; // Current state (0: S0, 1: S1)

always @(posedge clock) begin
    case (state)
        1'b0: // State S0
            if (a) begin
                state <= 1'b1; // Transition to S1
            end else begin
                state <= 1'b0; // Stay in S0
            end
        1'b1: // State S1
            if (!a) begin
                state <= 1'b0; // Transition to S0
            end else begin
                state <= 1'b1; // Stay in S1
            end
    endcase
    p <= a && state; // 'p' is high when 'a' is high and in state S1
    q <= state; // 'q' is high when in state S1
end

endmodule
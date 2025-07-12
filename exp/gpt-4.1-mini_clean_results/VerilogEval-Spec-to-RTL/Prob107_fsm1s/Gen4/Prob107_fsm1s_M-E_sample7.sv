module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state_B, state_A;

    // Next state logic combinational signals
    wire next_B = (state_B &  in) | (state_A & ~in);
    wire next_A = (state_B & ~in) | (state_A &  in);

    // State register update with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            state_B <= 1'b1;  // Reset to state B
            state_A <= 1'b0;
        end else begin
            state_B <= next_B;
            state_A <= next_A;
        end
    end

    // Output directly from B state (Moore machine)
    assign out = state_B;

endmodule
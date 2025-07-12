module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State registers (one-hot style)
    reg state_B;
    reg state_A;

    // Next state logic (combinational)
    wire next_B = (state_B & in) | (state_A & ~in);
    wire next_A = (state_A & in) | (state_B & ~in);

    // State registers with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state_B <= 1'b1;
            state_A <= 1'b0;
        end else begin
            state_B <= next_B;
            state_A <= next_A;
        end
    end

    // Output logic (combinational)
    assign out = state_B;

endmodule
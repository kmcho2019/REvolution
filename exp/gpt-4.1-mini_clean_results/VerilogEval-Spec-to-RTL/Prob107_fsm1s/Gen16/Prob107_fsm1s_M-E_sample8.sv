module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // One-hot state encoding
    reg A;
    reg B;

    // Next state signals
    wire next_A;
    wire next_B;

    // Next state logic
    assign next_B = (B & in) | (A & ~in);
    assign next_A = (B & ~in) | (A & in);

    // State registers with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            B <= 1'b1;  // Reset to state B
            A <= 1'b0;
        end else begin
            B <= next_B;
            A <= next_A;
        end
    end

    // Moore output depends only on state B
    assign out = B;

endmodule
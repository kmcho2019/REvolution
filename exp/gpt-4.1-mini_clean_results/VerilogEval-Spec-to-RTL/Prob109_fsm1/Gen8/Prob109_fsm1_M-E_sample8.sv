module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    // One-hot state encoding: state_A and state_B
    // state_A = 1 means state A active
    // state_B = 1 means state B active

    reg state_A;
    reg state_B;

    // Next state combinational logic
    wire next_A, next_B;

    // From the transition diagram:
    // B(1):
    //    if in=0 -> A
    //    if in=1 -> B
    // A(0):
    //    if in=0 -> B
    //    if in=1 -> A
    //
    // Encoding: 
    // next_A = (state_B & ~in) | (state_A & in)
    // next_B = (state_B & in)  | (state_A & ~in)

    assign next_A = (state_B & ~in) | (state_A & in);
    assign next_B = (state_B & in)  | (state_A & ~in);

    // State registers with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // reset to state B
            state_A <= 1'b0;
            state_B <= 1'b1;
        end else begin
            state_A <= next_A;
            state_B <= next_B;
        end
    end

    // Output is 1 when in state B, 0 in A
    assign out = state_B;

endmodule
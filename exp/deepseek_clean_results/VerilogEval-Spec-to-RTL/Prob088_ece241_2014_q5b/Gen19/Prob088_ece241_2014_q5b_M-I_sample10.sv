module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state_A;

    // Output logic simplified to XOR
    assign z = state_A ^ x;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;  // Reset to state A
        end else begin
            // Direct state transition rules:
            // Stay in A if x=0, move to B if x=1
            // Once in B, stay in B regardless of x
            state_A <= state_A & ~x;
        end
    end

endmodule
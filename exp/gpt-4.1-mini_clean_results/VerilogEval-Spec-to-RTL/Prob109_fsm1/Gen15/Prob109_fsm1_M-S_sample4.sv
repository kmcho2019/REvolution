module TopModule (
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    // State encoding: A = 0, B = 1
    always @(posedge clk or posedge areset) begin
        if (areset)
            out <= 1'b1;               // reset to state B (1)
        else
            out <= (out) ? in : ~in;  // if B(1): stay in B if in=1 else A(0); if A(0): stay in A if in=1 else B(1)
    end

endmodule
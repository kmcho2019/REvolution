module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Simplified comparison approach with mutual exclusivity
    assign A_greater = (A > B) ? 1'b1 : (A == B) ? 1'b0 : 1'b0;
    assign A_equal   = (A == B) ? 1'b1 : 1'b0;
    assign A_less    = (A < B) ? 1'b1 : 1'b0;

    // Alternatively, a more concise version could be:
    // assign {A_greater, A_equal, A_less} = (A > B) ? 3'b100 : (A == B) ? 3'b010 : 3'b001;

endmodule
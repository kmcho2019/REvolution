module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output reg        A_greater,
    output reg        A_equal,
    output reg        A_less
);

    assign A_greater = (A > B);
    assign A_equal = (A == B) && !(A > B);
    assign A_less = (A < B) && !(A > B) && !(A == B);

    // Alternatively, to make it clearer and ensure mutual exclusivity without relying on the priority of assignments:
    // assign A_greater = (A > B);
    // assign A_equal = ~(A_greater | A_less) && (A == B);
    // assign A_less = (A < B) && !(A_greater);

endmodule
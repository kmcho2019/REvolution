module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    assign A_equal = (A == B);
    assign A_greater = (A > B);
    assign A_less = (A < B);

    // Use a priority encoder or a similar logic to ensure mutual exclusivity
    // However, given the simplicity of the current design and the fact that
    // A_greater, A_equal, and A_less are inherently mutually exclusive due to
    // the nature of comparison, the above assignments suffice for most synthesis
    // tools to optimize correctly. Advanced techniques might involve more complex
    // logic optimization but are generally not necessary for such a simple comparator.

endmodule
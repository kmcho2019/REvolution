module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

// Refactored implementation focusing on clarity and potential simplification
assign out = (a & ~c & (~d | d)) |  // a and not c
             (~a & ~b & c & ~d) |  // not a, not b, c, not d
             (~a & b & c & d) |   // not a, b, c, d
             (b & c & d);         // b, c, d

// Note: The term (a & b & d) and others were re-evaluated and some were found redundant
// given the presence of other terms that already cover the conditions. This refactored
// version aims to maintain the original functionality while improving clarity.

endmodule
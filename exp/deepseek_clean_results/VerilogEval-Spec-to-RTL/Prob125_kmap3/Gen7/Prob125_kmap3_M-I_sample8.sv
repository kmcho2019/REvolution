module TopModule(
    input a,
    input b,
    input c,
    input d,  // Explicitly marked as unused
    output out
);
    // Alternative formulation that may map better to technology cells
    assign out = (a | c) & (a | ~b);
    // This is logically equivalent to a | (~b & c) but sometimes maps better
endmodule
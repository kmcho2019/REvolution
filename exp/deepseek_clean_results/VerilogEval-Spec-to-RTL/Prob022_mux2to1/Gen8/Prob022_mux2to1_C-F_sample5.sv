module TopModule (
    input wire a,
    input wire b,
    input wire sel,
    output wire out
);
    // Equivalent to:
    // a_path = a & ~sel
    // b_path = b & sel
    // out = a_path | b_path
    assign out = sel ? b : a;
endmodule
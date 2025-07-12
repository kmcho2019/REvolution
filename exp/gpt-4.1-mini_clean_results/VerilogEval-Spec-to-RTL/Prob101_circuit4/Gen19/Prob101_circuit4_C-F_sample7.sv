module TopModule (
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output wire q
);
    // Output q is high if either b or c is high, regardless of a and d
    assign q = b | c;
endmodule
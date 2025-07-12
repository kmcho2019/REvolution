module TopModule(
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output wire q
);
    // Output q is 1 when either b or c is 1, ignoring a and d
    assign q = b | c;
endmodule
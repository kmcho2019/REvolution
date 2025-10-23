module TopModule(
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output wire q
);
    // Output q is high when either b or c is high
    assign q = b | c;
endmodule
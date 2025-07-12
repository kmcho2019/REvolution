module TopModule (
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output wire q
);
    // Output q is high if either b or c is high; a and d are ignored
    assign q = b | c;
endmodule
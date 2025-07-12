module TopModule (
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output wire q
);
    // Directly implement q = b | c
    assign q = b | c;
endmodule
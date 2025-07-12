module TopModule (
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output wire q
);
    // Direct combinational assignment implementing q = b OR c
    assign q = b | c;
endmodule
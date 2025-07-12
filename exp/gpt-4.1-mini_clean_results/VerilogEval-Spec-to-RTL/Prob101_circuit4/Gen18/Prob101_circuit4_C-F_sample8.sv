module TopModule(
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output wire q
);
    // Direct combinational logic: q = b OR c
    assign q = b | c;
endmodule
module TopModule (
    input  a,
    input  b,
    output q
);
    // Combinational AND gate: output is high only when both inputs are high
    assign q = a & b;
endmodule
module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Direct continuous assignment implements combinational AND of inputs
    assign q = a & b;
endmodule
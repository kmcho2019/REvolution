module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Direct combinational AND of inputs a and b
    assign q = a & b;
endmodule
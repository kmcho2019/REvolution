module TopModule(a, b, q);
    input  logic a, b;
    output logic q;
    assign q = a & b;
endmodule
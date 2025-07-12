module TopModule (
    input  wire a,
    input  wire b,
    output logic out
);
    assign out = a ~^ b;
endmodule
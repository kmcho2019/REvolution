module TopModule(
    input [1:0] A,
    input [1:0] B,
    output logic z
);

assign z = (A === B);

endmodule
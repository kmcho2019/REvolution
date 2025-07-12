module TopModule(
    input x,
    input y,
    output logic z
);
    assign z = ~(x ^ y);
endmodule
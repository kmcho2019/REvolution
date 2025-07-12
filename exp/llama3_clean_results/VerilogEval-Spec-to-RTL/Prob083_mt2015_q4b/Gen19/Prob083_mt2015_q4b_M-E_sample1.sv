module TopModule(
    input x,
    input y,
    output logic z
);
    logic xor_out;
    assign xor_out = x ^ y;
    assign z = ~xor_out;
endmodule
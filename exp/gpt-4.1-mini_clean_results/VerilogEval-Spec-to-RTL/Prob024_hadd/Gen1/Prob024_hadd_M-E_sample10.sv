module TopModule(
    input a,
    input b,
    output sum,
    output cout
);
    wire xor_out;
    wire and_out;

    assign xor_out = a ^ b;
    assign and_out = a & b;

    assign sum = xor_out;
    assign cout = and_out;
endmodule
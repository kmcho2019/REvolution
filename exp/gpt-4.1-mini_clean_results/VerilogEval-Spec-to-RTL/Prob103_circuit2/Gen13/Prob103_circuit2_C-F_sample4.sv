module TopModule #(
    parameter WIDTH = 4
) (
    input  [WIDTH-1:0] inputs,
    output q
);

    // Even parity: output is inverted XOR of all input bits
    assign q = ~(^inputs);

endmodule
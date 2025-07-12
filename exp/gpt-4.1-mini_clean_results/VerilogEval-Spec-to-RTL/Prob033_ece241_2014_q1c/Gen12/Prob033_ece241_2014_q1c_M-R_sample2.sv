module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [8:0] sum_ext;

    // Perform addition with one extra bit to capture carry out
    assign sum_ext = {1'b0, a} + {1'b0, b};

    // Sum output is lower 8 bits
    assign s = sum_ext[7:0];

    // Overflow detection: XOR of carry into and out of MSB
    // Carry into MSB = sum_ext[7], Carry out MSB = sum_ext[8]
    assign overflow = sum_ext[7] ^ sum_ext[8];

endmodule
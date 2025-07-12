module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [8:0] sum_ext;

    // Perform addition with extra bit to catch carry out
    assign sum_ext = {1'b0, a} + {1'b0, b};

    // Sum is lower 8 bits
    assign s = sum_ext[7:0];

    // Carry into MSB is sum_ext[7], carry out of MSB is sum_ext[8]
    // Overflow occurs if these two differ
    assign overflow = sum_ext[7] ^ sum_ext[8];

endmodule
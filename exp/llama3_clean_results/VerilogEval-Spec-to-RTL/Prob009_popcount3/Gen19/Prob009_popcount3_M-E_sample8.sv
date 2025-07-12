module TopModule(
    input [2:0] in,  // 3-bit input vector
    output [1:0] out  // 2-bit output vector to hold the population count
);

    // Internal signals for the full adder cascade
    wire carry1;
    wire carry2;

    // First full adder: in[0] + in[1] + 0 (no carry)
    full_adder fa1(in[0], in[1], 1'b0, out[0], carry1);

    // Second full adder: carry1 + in[2] + 0 (no carry)
    full_adder fa2(carry1, in[2], 1'b0, out[1], carry2);

endmodule

// 1-bit full adder module
module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule
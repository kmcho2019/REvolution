module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);

    // Initialize the carry-in for the first full adder
    wire c0;
    assign c0 = 1'b0;

    // Full adder 1 (bit 0)
    wire c1, s0;
    full_adder fa0(x[0], y[0], c0, s0, c1);

    // Full adder 2 (bit 1)
    wire c2, s1;
    full_adder fa1(x[1], y[1], c1, s1, c2);

    // Full adder 3 (bit 2)
    wire c3, s2;
    full_adder fa2(x[2], y[2], c2, s2, c3);

    // Full adder 4 (bit 3)
    wire c4, s3;
    full_adder fa3(x[3], y[3], c3, s3, c4);

    // Assign the sum output
    assign sum[0] = s0;
    assign sum[1] = s1;
    assign sum[2] = s2;
    assign sum[3] = s3;
    assign sum[4] = c4;

endmodule

// Full adder module
module full_adder(
    input a,
    input b,
    input cin,
    output s,
    output cout
);

    // Calculate the sum and carry-out
    assign s = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule
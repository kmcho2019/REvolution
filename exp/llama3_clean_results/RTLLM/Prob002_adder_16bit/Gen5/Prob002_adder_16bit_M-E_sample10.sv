// Novel 16-bit full adder module using bitwise operations and carry-select adder
module adder_16bit_novel(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    // Precompute sums for Cin = 0 and Cin = 1
    wire [15:0] sum_cin0, sum_cin1;
    assign sum_cin0 = a ^ b;
    assign sum_cin1 = sum_cin0 ^ (16'b1 << 15);

    // Precompute carries for Cin = 0 and Cin = 1
    wire [15:0] carry_cin0, carry_cin1;
    assign carry_cin0 = (a & b) | (a & sum_cin0) | (b & sum_cin0);
    assign carry_cin1 = carry_cin0 | (16'b1 << 15);

    // Select correct sum and carry based on Cin
    assign y = Cin ? sum_cin1 : sum_cin0;
    assign Co = Cin ? carry_cin1[15] : carry_cin0[15];

endmodule
module FullAdder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    // Efficient full adder implementation
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    wire [2:0] save_sum;  // Saved sums for bits 0-2
    wire [2:0] save_carry; // Saved carries for bits 0-2
    wire final_carry;

    // Carry-save stage for bits 0-2 (parallel processing)
    FullAdder fa0(
        .a(x[0]),
        .b(y[0]),
        .cin(1'b0),
        .sum(save_sum[0]),
        .cout(save_carry[0])
    );

    FullAdder fa1(
        .a(x[1]),
        .b(y[1]),
        .cin(1'b0),
        .sum(save_sum[1]),
        .cout(save_carry[1])
    );

    FullAdder fa2(
        .a(x[2]),
        .b(y[2]),
        .cin(1'b0),
        .sum(save_sum[2]),
        .cout(save_carry[2])
    );

    // Final ripple stage for bit 3 and overflow
    FullAdder fa3(
        .a(x[3]),
        .b(y[3]),
        .cin(save_carry[2]),
        .sum(sum[3]),
        .cout(sum[4])
    );

    // Combine saved sums and carries
    assign sum[0] = save_sum[0];
    assign sum[1] = save_sum[1] ^ save_carry[0];
    assign sum[2] = save_sum[2] ^ save_carry[1];
endmodule
module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;

    // 4-bit addition with carry-out
    assign raw_sum = {1'b0, A} + {1'b0, B} + Cin;

    // Determine if correction is needed:
    // correction if sum > 9 or if carry-out is set
    wire correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Apply BCD correction by adding 6 (0110) conditionally using combinational logic
    // Instead of adding 6 with an adder, use bitwise operations:
    // Sum[0] = raw_sum[0]
    // Sum[1] = raw_sum[1] ^ correction_needed
    // Sum[2] = raw_sum[2] ^ correction_needed
    // Sum[3] = raw_sum[3] | correction_needed
    assign Sum[0] = raw_sum[0];
    assign Sum[1] = raw_sum[1] ^ correction_needed;
    assign Sum[2] = raw_sum[2] ^ correction_needed;
    assign Sum[3] = raw_sum[3] | correction_needed;

    // Cout is just correction_needed indicating carry-out from BCD digit
    assign Cout = correction_needed;

endmodule
module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum = A + B + Cin;  // 5-bit raw sum: sum and carry

    // Compute corrected sum by adding 6 (4'b0110) to raw_sum's lower 4 bits
    wire [4:0] corrected_sum;

    wire [4:0] add_six = {1'b0, 4'b0110};

    assign corrected_sum = raw_sum + add_six;

    // BCD invalid if raw_sum > 9
    // raw_sum is 5-bit unsigned number, check raw_sum > 9
    // 9 decimal = 5'b01001
    wire invalid_bcd = (raw_sum > 5'd9);

    // Select final sum and carry based on invalid_bcd
    assign Sum  = invalid_bcd ? corrected_sum[3:0] : raw_sum[3:0];
    assign Cout = invalid_bcd ? corrected_sum[4]   : raw_sum[4];

endmodule
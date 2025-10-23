module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] initial_sum;
    wire       add_correction;
    wire [4:0] sum_with_correction;

    // 5-bit binary addition
    assign initial_sum = A + B + Cin;

    // Determine if correction is required:
    // Correction needed if sum > 9
    // Using combinational logic: sum > 9 if
    // - initial_sum[4] == 1 (sum >= 16), or
    // - initial_sum[3] == 1 and (initial_sum[2] == 1 or initial_sum[1] == 1)
    assign add_correction = initial_sum[4] | (initial_sum[3] & (initial_sum[2] | initial_sum[1]));

    // Add 6 if correction is needed
    assign sum_with_correction = initial_sum + (add_correction ? 5'd6 : 5'd0);

    // Outputs
    assign Sum  = sum_with_correction[3:0];
    assign Cout = add_correction;

endmodule
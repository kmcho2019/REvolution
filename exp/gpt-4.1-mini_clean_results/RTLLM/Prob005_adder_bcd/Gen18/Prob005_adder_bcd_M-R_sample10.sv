module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] initial_sum;
    wire       correction;
    wire [4:0] corrected_sum;

    // Step 1: Add A, B, and Cin (4-bit addition with carry out)
    assign {initial_sum[4], initial_sum[3:0]} = A + B + Cin;

    // Step 2: Determine if correction is needed (sum > 9 or carry out set)
    assign correction = (initial_sum > 5'd9);

    // Step 3: Add 6 if correction needed
    assign corrected_sum = initial_sum + (correction ? 5'd6 : 5'd0);

    // Step 4: Output corrected BCD sum and carry out (Cout)
    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule
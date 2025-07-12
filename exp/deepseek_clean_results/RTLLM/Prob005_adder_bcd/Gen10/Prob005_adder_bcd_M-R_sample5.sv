module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Intermediate signals
    wire [3:0] initial_sum;
    wire [3:0] corrected_sum;
    wire [4:0] full_sum;
    wire need_correction;

    // Initial binary addition
    assign initial_sum = A + B + Cin;

    // BCD correction condition (sum > 9 or carry out)
    // Detects patterns: 1010, 1011, 1100, 1101, 1110, 1111
    assign need_correction = (initial_sum[3] & (initial_sum[2] | initial_sum[1])) | 
                            (initial_sum > 4'd9);

    // Apply correction (add 6 if needed)
    assign corrected_sum = need_correction ? (initial_sum + 4'd6) : initial_sum;

    // Final sum and carry out
    assign full_sum = A + B + Cin + (need_correction ? 5'd6 : 5'd0);
    assign Sum = full_sum[3:0];
    assign Cout = full_sum[4];

endmodule
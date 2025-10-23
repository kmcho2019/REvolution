module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Calculate the binary sum of A, B, and Cin
    wire [4:0] bin_sum = A + B + Cin;

    // Determine Cout based on whether bin_sum exceeds 9
    assign Cout = (bin_sum > 9)? 1'b1 : 1'b0;

    // Calculate Sum with BCD correction
    assign Sum = (bin_sum > 9)? (bin_sum[3:0] + 4'd6) : bin_sum[3:0];

    // Alternative implementation to reduce switching activity
    // assign Sum = (bin_sum > 9)? {1'b0, bin_sum[3:1] + 3'd6, bin_sum[0]} : bin_sum[3:0];

endmodule
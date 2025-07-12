module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] binary_sum;
    reg  [4:0] corrected_sum;
    wire       correction_needed;

    // Binary addition of A, B and Cin
    assign binary_sum = A + B + Cin;

    // Determine if correction is needed (sum > 9 or carry out)
    assign correction_needed = (binary_sum[4] == 1'b1) || (binary_sum[3:0] > 4'd9);

    always @(*) begin
        if (correction_needed)
            corrected_sum = binary_sum + 5'd6;  // Add 6 for BCD correction
        else
            corrected_sum = binary_sum;
    end

    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule
module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output reg [3:0] Sum,
    output reg       Cout
);

    reg [4:0] raw_sum;
    reg       correction_needed;
    reg [4:0] corrected_sum;

    always @(*) begin
        raw_sum = A + B + Cin;
        // Correction needed if sum > 9 (1001) or overflow in 5-bit sum
        correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));
        if (correction_needed)
            corrected_sum = raw_sum + 5'd6;
        else
            corrected_sum = raw_sum;

        Sum  = corrected_sum[3:0];
        Cout = corrected_sum[4];
    end

endmodule
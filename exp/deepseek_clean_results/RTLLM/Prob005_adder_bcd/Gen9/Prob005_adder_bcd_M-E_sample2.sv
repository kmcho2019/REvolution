module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Early prediction of possible overflow (A+B >= 10)
    wire will_overflow = (A > 4'd9) | (B > 4'd9) | 
                       ((A == 4'd9) & (B >= 4'd1)) |
                       ((A == 4'd8) & (B >= 4'd2)) |
                       ((A == 4'd7) & (B >= 4'd3)) |
                       ((A == 4'd6) & (B >= 4'd4)) |
                       ((A >= 4'd5) & (B >= 4'd5));

    // Compute both possible sums in parallel
    wire [4:0] sum_raw = A + B + Cin;
    wire [4:0] sum_corrected = sum_raw + 5'd6;

    // Select appropriate result based on prediction
    assign {Cout, Sum} = (will_overflow | (sum_raw > 5'd9)) ? sum_corrected : sum_raw;

endmodule
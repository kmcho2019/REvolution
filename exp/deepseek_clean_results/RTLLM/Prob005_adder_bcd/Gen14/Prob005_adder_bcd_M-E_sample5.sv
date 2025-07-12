module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Early correction prediction
    // Correction needed if any of these conditions are true:
    // 1. A + B + Cin >= 10 (decimal)
    // 2. A + B + Cin produces a carry (binary sum > 15)
    // We can predict this by examining input patterns
    wire correction_needed = 
        (A > 4'd9) | (B > 4'd9) |  // Illegal BCD inputs (optional protection)
        ((A == 4'd9) & (B != 4'd0) & (Cin == 1'b1)) |  // 9 + x + 1
        ((A == 4'd8) & (B >= 4'd2)) |                   // 8 + 2-9
        ((A == 4'd7) & (B >= 4'd3)) |                   // 7 + 3-9
        ((A == 4'd6) & (B >= 4'd4)) |                   // 6 + 4-9
        ((A == 4'd5) & (B >= 4'd5)) |                   // 5 + 5-9
        ((A >= 4'd4) & (B >= 4'd6)) |                   // 4-9 + 6-9
        ((A >= 4'd3) & (B >= 4'd7)) |                   // 3-9 + 7-9
        ((A >= 4'd2) & (B >= 4'd8)) |                   // 2-9 + 8-9
        ((A >= 4'd1) & (B >= 4'd9));                    // 1-9 + 9

    // Compute both possible sums in parallel
    wire [3:0] sum_no_correction = A + B + Cin;
    wire [3:0] sum_with_correction = A + B + Cin + 4'd6;
    
    // Select correct sum based on prediction
    assign Sum = correction_needed ? sum_with_correction : sum_no_correction;
    assign Cout = correction_needed;

endmodule
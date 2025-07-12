module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Stage 1: Compute sum and carry without correction
    wire [3:0] raw_sum = A + B;
    wire raw_carry = (raw_sum + Cin) > 4'd9;

    // Optimized correction detection (equivalent to sum > 9)
    // Detects patterns: 1xxx or x11x (where x is don't care)
    wire correction_needed = raw_carry | 
                           (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Gated correction adder - only activates when needed
    wire [3:0] sum_plus_6 = raw_sum + 4'd6 + Cin;
    wire [3:0] sum_plus_0 = raw_sum + Cin;

    // Final output selection
    assign Sum = correction_needed ? sum_plus_6 : sum_plus_0;
    assign Cout = correction_needed;

endmodule
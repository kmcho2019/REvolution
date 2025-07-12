module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Predictive correction logic
    wire will_overflow = (A > 4'd9) | (B > 4'd9) |  // Invalid BCD inputs
                       ((A == 4'd9) & (B > 4'd0)) | // Will overflow without carry
                       ((A >= 4'd5) & (B >= 4'd5));  // Sum will be >=10

    // Final correction decision (combine prediction with actual carry)
    wire do_correction = will_overflow | (Cin & ((A + B) >= 4'd9));

    // Parallel computation paths
    wire [3:0] binary_sum = A + B + Cin;
    wire [3:0] corrected_sum = binary_sum + 4'd6;

    // Output selection
    assign Sum = do_correction ? corrected_sum : binary_sum;
    assign Cout = do_correction | (binary_sum > 4'd9);

endmodule
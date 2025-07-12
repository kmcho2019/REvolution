module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Predictive correction signal
    // Will be 1 if we predict sum will need +6 correction
    wire correction_needed = (A > 4'd4 && B > 4'd4) ||  // Both >5 will always need correction
                           (A > 4'd7) ||               // Either >7 will likely need correction
                           (B > 4'd7) ||
                           (A + B + Cin > 4'd9);       // Direct prediction

    // Compute both possible sums in parallel
    wire [4:0] raw_sum = A + B + Cin;
    wire [4:0] corrected_sum = raw_sum + 4'd6;

    // Select appropriate sum based on prediction
    assign Sum = correction_needed ? corrected_sum[3:0] : raw_sum[3:0];
    
    // Carry out is either from raw sum (if no correction) or corrected sum (if correction)
    assign Cout = correction_needed ? corrected_sum[4] : raw_sum[4];

endmodule
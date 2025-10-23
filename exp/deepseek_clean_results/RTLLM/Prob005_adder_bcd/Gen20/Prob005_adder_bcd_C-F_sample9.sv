module adder_bcd (
    input [3:0] A,    // First BCD digit (0-9)
    input [3:0] B,    // Second BCD digit (0-9)
    input Cin,        // Carry-in
    output [3:0] Sum, // Corrected BCD sum
    output Cout       // Carry-out
);

    // Compute raw binary sum (5 bits to capture overflow)
    wire [4:0] raw_sum = A + B + Cin;
    
    // Correction needed if:
    // 1) Raw sum exceeds 9 (1001), OR
    // 2) There's a carry-out (raw_sum[4] is set)
    wire correction_needed = (raw_sum[3:0] > 4'd9) || raw_sum[4];
    
    // Apply correction: add 6 if needed, otherwise add 0
    // This also automatically handles the carry-out for sums >15
    assign Sum = raw_sum[3:0] + (correction_needed ? 4'd6 : 4'd0);
    
    // Carry-out is set when correction is needed
    assign Cout = correction_needed;

endmodule
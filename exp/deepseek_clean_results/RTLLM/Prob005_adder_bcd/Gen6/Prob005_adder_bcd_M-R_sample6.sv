module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Binary addition including carry-in
    wire [4:0] binary_sum = A + B + Cin;
    
    // Detect if sum exceeds 9 or generated carry
    wire needs_correction = (binary_sum[4]) ||  // Carry out from binary addition
                           (binary_sum[3:0] > 4'd9);  // Sum > 9
    
    // Apply BCD correction (add 6 if needed)
    wire [4:0] corrected_sum = binary_sum + (needs_correction ? 5'd6 : 5'd0);
    
    // Final outputs
    assign Sum = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule
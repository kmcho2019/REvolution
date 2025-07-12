module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute raw sum including carry-out
    wire [4:0] raw_sum = A + B + Cin;
    
    // Detect if correction needed (sum > 9)
    wire need_correction = (raw_sum[4] |          // Sum >= 16
                          (raw_sum[3] & (raw_sum[2] | raw_sum[1])));  // Sum 10-15

    // Apply correction if needed (add 6 when sum > 9)
    assign Sum = need_correction ? (raw_sum[3:0] + 4'b0110) : raw_sum[3:0];
    
    // Carry out is set when correction is needed
    assign Cout = need_correction;

endmodule
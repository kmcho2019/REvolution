module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Combined sum and correction calculation
    wire [4:0] raw_sum = A + B + Cin;
    wire need_correction = (raw_sum > 9) | raw_sum[4];
    
    // Final sum with conditional correction
    assign Sum = raw_sum[3:0] + (need_correction ? 4'd6 : 4'd0);
    
    // Carry generation
    assign Cout = need_correction;

endmodule
module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute initial sum with carry-out
    wire [4:0] initial_sum = A + B + Cin;
    
    // Optimized BCD correction detection:
    // Either sum > 9 (1001) or carry-out occurred (sum[4])
    wire correction_needed = (initial_sum[3:0] > 4'd9) | initial_sum[4];
    
    // Apply correction (either +0 or +6) using efficient conditional
    assign Sum = correction_needed ? (initial_sum[3:0] + 4'd6) : initial_sum[3:0];
    assign Cout = correction_needed;

endmodule
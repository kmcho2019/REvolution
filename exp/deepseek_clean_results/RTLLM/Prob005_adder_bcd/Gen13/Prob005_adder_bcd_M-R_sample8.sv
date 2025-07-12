module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Intermediate sum before correction (5-bit to capture carry)
    wire [4:0] raw_sum = A + B + Cin;

    // Correction condition signals
    wire sum_gt_9 = (raw_sum[3] & (raw_sum[2] | raw_sum[1])) | raw_sum[4];
    
    // Correction value (0 or 6)
    wire [3:0] correction = {4{sum_gt_9}} & 4'd6;

    // Final corrected sum
    assign Sum = raw_sum[3:0] + correction;

    // Carry out is same as correction condition
    assign Cout = sum_gt_9;

endmodule
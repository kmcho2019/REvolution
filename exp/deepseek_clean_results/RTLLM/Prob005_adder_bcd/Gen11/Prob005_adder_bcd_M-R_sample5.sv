module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Stage 1: Initial binary sum
    wire [4:0] initial_sum = A + B + Cin;
    
    // Stage 2: Correction detection
    wire sum_gt_9 = (initial_sum > 5'd9);
    wire correction_needed = sum_gt_9 | initial_sum[4];
    
    // Stage 3: Correction value selection
    wire [3:0] correction_value = correction_needed ? 4'd6 : 4'd0;
    
    // Stage 4: Final sum with correction
    wire [4:0] final_sum = initial_sum + correction_value;
    
    // Output assignment
    assign Sum = final_sum[3:0];
    assign Cout = final_sum[4];
    
endmodule
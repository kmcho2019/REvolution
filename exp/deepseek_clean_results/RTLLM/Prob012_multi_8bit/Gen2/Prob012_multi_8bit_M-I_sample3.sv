module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Zero detection for power optimization
    wire zero_input = (A == 8'b0) || (B == 8'b0);
    
    // Generate all 8 partial products with combined shift and mask
    wire [15:0] pp[7:0];
    assign pp[0] = {{8{1'b0}}, A} & {16{B[0] & ~zero_input}};
    assign pp[1] = {{7{1'b0}}, A, 1'b0} & {16{B[1] & ~zero_input}};
    assign pp[2] = {{6{1'b0}}, A, 2'b0} & {16{B[2] & ~zero_input}};
    assign pp[3] = {{5{1'b0}}, A, 3'b0} & {16{B[3] & ~zero_input}};
    assign pp[4] = {{4{1'b0}}, A, 4'b0} & {16{B[4] & ~zero_input}};
    assign pp[5] = {{3{1'b0}}, A, 5'b0} & {16{B[5] & ~zero_input}};
    assign pp[6] = {{2{1'b0}}, A, 6'b0} & {16{B[6] & ~zero_input}};
    assign pp[7] = {{1{1'b0}}, A, 7'b0} & {16{B[7] & ~zero_input}};

    // First level: Carry-save adders (3:2 compressors)
    wire [15:0] sum01, carry01;
    assign {carry01, sum01} = pp[0] + pp[1] + pp[2];
    
    wire [15:0] sum23, carry23;
    assign {carry23, sum23} = pp[3] + pp[4] + pp[5];
    
    // Second level: Regular adders
    wire [15:0] sum_carry01 = sum01 + (carry01 << 1);
    wire [15:0] sum_carry23 = sum23 + (carry23 << 1);
    
    // Final adder with zero input bypass
    wire [15:0] final_sum = sum_carry01 + sum_carry23 + pp[6] + pp[7];
    assign product = zero_input ? 16'b0 : final_sum;

endmodule
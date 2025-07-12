module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Booth encoding (Radix-2)
    wire [8:0] B_ext = {B, 1'b0};
    wire [7:0] A_neg = ~A + 1'b1;
    
    // Generate Booth-encoded partial products
    wire [15:0] pp0, pp1, pp2, pp3;
    
    assign pp0 = (B_ext[1:0] == 2'b01) ? {8'b0, A} :
                (B_ext[1:0] == 2'b10) ? {8'b0, A_neg} :
                16'b0;
    
    assign pp1 = (B_ext[3:1] == 3'b001) ? {6'b0, A, 2'b0} :
                (B_ext[3:1] == 3'b010) ? {6'b0, A, 2'b0} :
                (B_ext[3:1] == 3'b011) ? {5'b0, A, 3'b0} :
                (B_ext[3:1] == 3'b100) ? {5'b0, A_neg, 3'b0} :
                (B_ext[3:1] == 3'b101) ? {6'b0, A_neg, 2'b0} :
                16'b0;
    
    assign pp2 = (B_ext[5:3] == 3'b001) ? {4'b0, A, 4'b0} :
                (B_ext[5:3] == 3'b010) ? {4'b0, A, 4'b0} :
                (B_ext[5:3] == 3'b011) ? {3'b0, A, 5'b0} :
                (B_ext[5:3] == 3'b100) ? {3'b0, A_neg, 5'b0} :
                (B_ext[5:3] == 3'b101) ? {4'b0, A_neg, 4'b0} :
                16'b0;
    
    assign pp3 = (B_ext[7:5] == 3'b001) ? {2'b0, A, 6'b0} :
                (B_ext[7:5] == 3'b010) ? {2'b0, A, 6'b0} :
                (B_ext[7:5] == 3'b011) ? {1'b0, A, 7'b0} :
                (B_ext[7:5] == 3'b100) ? {1'b0, A_neg, 7'b0} :
                (B_ext[7:5] == 3'b101) ? {2'b0, A_neg, 6'b0} :
                16'b0;
    
    // Carry-save addition tree
    wire [15:0] sum0, carry0;
    wire [15:0] sum1, carry1;
    
    // First level of CSA
    assign {carry0, sum0} = pp0 + pp1;
    
    // Second level of CSA
    assign {carry1, sum1} = sum0 + pp2;
    
    // Final addition with carry-lookahead
    wire [15:0] temp_sum = sum1 + pp3;
    wire [15:0] temp_carry = {carry0[14:0], 1'b0} + {carry1[14:0], 1'b0};
    
    // Final product
    assign product = temp_sum + temp_carry;

endmodule
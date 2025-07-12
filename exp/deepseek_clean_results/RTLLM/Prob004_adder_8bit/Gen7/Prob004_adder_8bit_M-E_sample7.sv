module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Lower 4-bit ripple-carry adder
    wire [3:0] lower_sum;
    wire lower_cout;
    wire [4:0] lower_carry;
    
    assign lower_carry[0] = cin;
    
    // Bit 0
    assign lower_sum[0] = a[0] ^ b[0] ^ lower_carry[0];
    assign lower_carry[1] = (a[0] & b[0]) | (lower_carry[0] & (a[0] | b[0]));
    
    // Bit 1
    assign lower_sum[1] = a[1] ^ b[1] ^ lower_carry[1];
    assign lower_carry[2] = (a[1] & b[1]) | (lower_carry[1] & (a[1] | b[1]));
    
    // Bit 2
    assign lower_sum[2] = a[2] ^ b[2] ^ lower_carry[2];
    assign lower_carry[3] = (a[2] & b[2]) | (lower_carry[2] & (a[2] | b[2]));
    
    // Bit 3
    assign lower_sum[3] = a[3] ^ b[3] ^ lower_carry[3];
    assign lower_cout = (a[3] & b[3]) | (lower_carry[3] & (a[3] | b[3]));

    // Upper 4-bit carry-select adder
    wire [3:0] upper_sum0, upper_sum1;
    wire upper_cout0, upper_cout1;
    
    // Upper sum assuming carry-in 0
    assign upper_sum0[0] = a[4] ^ b[4];
    wire c1_0 = a[4] & b[4];
    
    assign upper_sum0[1] = a[5] ^ b[5] ^ c1_0;
    wire c2_0 = (a[5] & b[5]) | (c1_0 & (a[5] | b[5]));
    
    assign upper_sum0[2] = a[6] ^ b[6] ^ c2_0;
    wire c3_0 = (a[6] & b[6]) | (c2_0 & (a[6] | b[6]));
    
    assign upper_sum0[3] = a[7] ^ b[7] ^ c3_0;
    assign upper_cout0 = (a[7] & b[7]) | (c3_0 & (a[7] | b[7]));
    
    // Upper sum assuming carry-in 1
    assign upper_sum1[0] = a[4] ^ b[4] ^ 1'b1;
    wire c1_1 = (a[4] & b[4]) | (1'b1 & (a[4] | b[4]));
    
    assign upper_sum1[1] = a[5] ^ b[5] ^ c1_1;
    wire c2_1 = (a[5] & b[5]) | (c1_1 & (a[5] | b[5]));
    
    assign upper_sum1[2] = a[6] ^ b[6] ^ c2_1;
    wire c3_1 = (a[6] & b[6]) | (c2_1 & (a[6] | b[6]));
    
    assign upper_sum1[3] = a[7] ^ b[7] ^ c3_1;
    assign upper_cout1 = (a[7] & b[7]) | (c3_1 & (a[7] | b[7]));

    // Select upper result based on lower carry-out
    assign sum[7:4] = lower_cout ? upper_sum1 : upper_sum0;
    assign sum[3:0] = lower_sum;
    assign cout = lower_cout ? upper_cout1 : upper_cout0;

endmodule
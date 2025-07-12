module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Internal signals
    wire [3:0] carry;
    wire [7:0] sum0_case, sum1_case;
    
    // First 2-bit ripple-carry block (bits 0-1)
    assign sum[0] = a[0] ^ b[0] ^ cin;
    wire carry0 = (a[0] & b[0]) | (cin & (a[0] ^ b[0]));
    
    assign sum[1] = a[1] ^ b[1] ^ carry0;
    assign carry[0] = (a[1] & b[1]) | (carry0 & (a[1] ^ b[1]));
    
    // 2-bit carry-select blocks (bits 2-7)
    // Block 1 (bits 2-3)
    assign sum0_case[2] = a[2] ^ b[2] ^ 1'b0;
    assign sum1_case[2] = a[2] ^ b[2] ^ 1'b1;
    assign sum0_case[3] = a[3] ^ b[3] ^ (a[2] & b[2]);
    assign sum1_case[3] = a[3] ^ b[3] ^ ((a[2] & b[2]) | (1'b1 & (a[2] ^ b[2])));
    
    assign sum[2] = carry[0] ? sum1_case[2] : sum0_case[2];
    assign sum[3] = carry[0] ? sum1_case[3] : sum0_case[3];
    assign carry[1] = carry[0] ? ((a[3] & b[3]) | ((a[2] & b[2]) | (1'b1 & (a[2] ^ b[2]))) & (a[3] ^ b[3]))) 
                               : ((a[3] & b[3]) | (a[2] & b[2] & (a[3] ^ b[3])));
    
    // Block 2 (bits 4-5)
    assign sum0_case[4] = a[4] ^ b[4] ^ 1'b0;
    assign sum1_case[4] = a[4] ^ b[4] ^ 1'b1;
    assign sum0_case[5] = a[5] ^ b[5] ^ (a[4] & b[4]);
    assign sum1_case[5] = a[5] ^ b[5] ^ ((a[4] & b[4]) | (1'b1 & (a[4] ^ b[4])));
    
    assign sum[4] = carry[1] ? sum1_case[4] : sum0_case[4];
    assign sum[5] = carry[1] ? sum1_case[5] : sum0_case[5];
    assign carry[2] = carry[1] ? ((a[5] & b[5]) | ((a[4] & b[4]) | (1'b1 & (a[4] ^ b[4]))) & (a[5] ^ b[5]))) 
                               : ((a[5] & b[5]) | (a[4] & b[4] & (a[5] ^ b[5])));
    
    // Block 3 (bits 6-7)
    assign sum0_case[6] = a[6] ^ b[6] ^ 1'b0;
    assign sum1_case[6] = a[6] ^ b[6] ^ 1'b1;
    assign sum0_case[7] = a[7] ^ b[7] ^ (a[6] & b[6]);
    assign sum1_case[7] = a[7] ^ b[7] ^ ((a[6] & b[6]) | (1'b1 & (a[6] ^ b[6])));
    
    assign sum[6] = carry[2] ? sum1_case[6] : sum0_case[6];
    assign sum[7] = carry[2] ? sum1_case[7] : sum0_case[7];
    assign cout = carry[2] ? ((a[7] & b[7]) | ((a[6] & b[6]) | (1'b1 & (a[6] ^ b[6]))) & (a[7] ^ b[7]))) 
                          : ((a[7] & b[7]) | (a[6] & b[6] & (a[7] ^ b[7])));

endmodule
module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Internal carry signals
    wire [7:0] c;
    wire [2:0] block_propagate;
    wire [2:0] block_generate;
    wire [2:0] block_carry;
    
    // First block (bits 2:0)
    assign sum[0] = a[0] ^ b[0] ^ cin;
    assign c[0] = (a[0] & b[0]) | (cin & (a[0] ^ b[0]));
    
    assign sum[1] = a[1] ^ b[1] ^ c[0];
    assign c[1] = (a[1] & b[1]) | (c[0] & (a[1] ^ b[1]));
    
    assign sum[2] = a[2] ^ b[2] ^ c[1];
    assign block_generate[0] = (a[2] & b[2]) | (c[1] & (a[2] | b[2]));
    assign block_propagate[0] = (a[0] | b[0]) & (a[1] | b[1]) & (a[2] | b[2]);
    
    // Second block (bits 4:3)
    assign block_carry[1] = block_generate[0] | (block_propagate[0] & cin);
    
    assign sum[3] = a[3] ^ b[3] ^ block_carry[1];
    assign c[3] = (a[3] & b[3]) | (block_carry[1] & (a[3] ^ b[3]));
    
    assign sum[4] = a[4] ^ b[4] ^ c[3];
    assign block_generate[1] = (a[4] & b[4]) | (c[3] & (a[4] | b[4]));
    assign block_propagate[1] = (a[3] | b[3]) & (a[4] | b[4]);
    
    // Third block (bits 7:5)
    assign block_carry[2] = block_generate[1] | (block_propagate[1] & block_generate[0]) | 
                          (block_propagate[1] & block_propagate[0] & cin);
    
    assign sum[5] = a[5] ^ b[5] ^ block_carry[2];
    assign c[5] = (a[5] & b[5]) | (block_carry[2] & (a[5] ^ b[5]));
    
    assign sum[6] = a[6] ^ b[6] ^ c[5];
    assign c[6] = (a[6] & b[6]) | (c[5] & (a[6] ^ b[6]));
    
    assign sum[7] = a[7] ^ b[7] ^ c[6];
    assign block_generate[2] = (a[7] & b[7]) | (c[6] & (a[7] | b[7]));
    
    // Final carry out
    assign cout = block_generate[2] | 
                 (block_propagate[1] & block_generate[1]) |
                 (block_propagate[1] & block_propagate[0] & block_generate[0]) |
                 (block_propagate[1] & block_propagate[0] & cin);

endmodule
module half_adder(
    input   a,
    input   b,
    output  sum,
    output  cout
);
    
    assign sum = a ^ b;
    assign cout = a & b;
    
endmodule

module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);
    
    wire [7:0] c;
    wire [7:0] s;
    
    // Compute sum and carry bits for each bit position
    half_adder u0 (.a(a[0]), .b(b[0]), .sum(s[0]), .cout(c[0]));
    half_adder u1 (.a(a[1]), .b(b[1]), .sum(s[1]), .cout(c[1]));
    half_adder u2 (.a(a[2]), .b(b[2]), .sum(s[2]), .cout(c[2]));
    half_adder u3 (.a(a[3]), .b(b[3]), .sum(s[3]), .cout(c[3]));
    half_adder u4 (.a(a[4]), .b(b[4]), .sum(s[4]), .cout(c[4]));
    half_adder u5 (.a(a[5]), .b(b[5]), .sum(s[5]), .cout(c[5]));
    half_adder u6 (.a(a[6]), .b(b[6]), .sum(s[6]), .cout(c[6]));
    half_adder u7 (.a(a[7]), .b(b[7]), .sum(s[7]), .cout(c[7]));
    
    // Compute final carry bits
    assign c[0] = c[0] | cin;
    assign c[1] = c[1] | c[0];
    assign c[2] = c[2] | c[1];
    assign c[3] = c[3] | c[2];
    assign c[4] = c[4] | c[3];
    assign c[5] = c[5] | c[4];
    assign c[6] = c[6] | c[5];
    assign c[7] = c[7] | c[6];
    
    // Compute final sum bits
    assign sum[0] = s[0] ^ cin;
    assign sum[1] = s[1] ^ c[0];
    assign sum[2] = s[2] ^ c[1];
    assign sum[3] = s[3] ^ c[2];
    assign sum[4] = s[4] ^ c[3];
    assign sum[5] = s[5] ^ c[4];
    assign sum[6] = s[6] ^ c[5];
    assign sum[7] = s[7] ^ c[6];
    
    // Compute final carry bit
    assign cout = c[7];
    
endmodule
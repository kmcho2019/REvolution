// 2-bit adder module
module adder_2bit(
    input   [1:0] a,
    input   [1:0] b,
    input       cin,
    output  [1:0] sum,
    output      cout
);
    
    assign sum[0] = a[0] ^ b[0] ^ cin;
    assign sum[1] = a[1] ^ b[1] ^ (a[0] & b[0]) ^ (a[0] & cin) ^ (b[0] & cin);
    assign cout = (a[1] & b[1]) | (a[1] & (a[0] & b[0]) ^ (a[0] & cin) ^ (b[0] & cin)) | (b[1] & (a[0] & b[0]) ^ (a[0] & cin) ^ (b[0] & cin));
    
endmodule

// Carry-merge unit
module carry_merge(
    input   [3:0] cin,
    output      cout
);
    
    assign cout = cin[0] | cin[1] | cin[2] | cin[3];
    
endmodule

// 8-bit adder module
module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);
    
    wire [1:0] sum0, sum1, sum2, sum3;
    wire [3:0] c;
    wire cin0, cin1, cin2, cin3;
    
    assign cin0 = cin;
    assign cin1 = c[0];
    assign cin2 = c[1];
    assign cin3 = c[2];
    
    adder_2bit u0 (.a(a[1:0]), .b(b[1:0]), .cin(cin0), .sum(sum0), .cout(c[0]));
    adder_2bit u1 (.a(a[3:2]), .b(b[3:2]), .cin(cin1), .sum(sum1), .cout(c[1]));
    adder_2bit u2 (.a(a[5:4]), .b(b[5:4]), .cin(cin2), .sum(sum2), .cout(c[2]));
    adder_2bit u3 (.a(a[7:6]), .b(b[7:6]), .cin(cin3), .sum(sum3), .cout(c[3]));
    
    carry_merge u4 (.cin(c), .cout(cout));
    
    assign sum[1:0] = sum0;
    assign sum[3:2] = sum1;
    assign sum[5:4] = sum2;
    assign sum[7:6] = sum3;
    
endmodule
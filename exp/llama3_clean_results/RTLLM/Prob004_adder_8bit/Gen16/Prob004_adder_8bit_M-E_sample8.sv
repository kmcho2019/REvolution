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

module carry_lookahead(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output      cout
);
    
    wire c0, c1, c2, c3;
    
    assign c0 = (a[1] & b[1]) | (a[1] & (a[0] & b[0]) ^ (a[0] & cin) ^ (b[0] & cin)) | (b[1] & (a[0] & b[0]) ^ (a[0] & cin) ^ (b[0] & cin));
    assign c1 = (a[3] & b[3]) | (a[3] & (a[2] & b[2]) ^ (a[2] & c0) ^ (b[2] & c0)) | (b[3] & (a[2] & b[2]) ^ (a[2] & c0) ^ (b[2] & c0));
    assign c2 = (a[5] & b[5]) | (a[5] & (a[4] & b[4]) ^ (a[4] & c1) ^ (b[4] & c1)) | (b[5] & (a[4] & b[4]) ^ (a[4] & c1) ^ (b[4] & c1));
    assign c3 = (a[7] & b[7]) | (a[7] & (a[6] & b[6]) ^ (a[6] & c2) ^ (b[6] & c2)) | (b[7] & (a[6] & b[6]) ^ (a[6] & c2) ^ (b[6] & c2));
    
    assign cout = c3;
    
endmodule

module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);
    
    wire c0, c1, c2;
    
    adder_2bit u0 (.a(a[1:0]), .b(b[1:0]), .cin(cin), .sum(sum[1:0]), .cout(c0));
    adder_2bit u1 (.a(a[3:2]), .b(b[3:2]), .cin(c0), .sum(sum[3:2]), .cout(c1));
    adder_2bit u2 (.a(a[5:4]), .b(b[5:4]), .cin(c1), .sum(sum[5:4]), .cout(c2));
    adder_2bit u3 (.a(a[7:6]), .b(b[7:6]), .cin(c2), .sum(sum[7:6]), .cout(cout));
    
    carry_lookahead cl (.a(a), .b(b), .cin(cin), .cout());
    
endmodule
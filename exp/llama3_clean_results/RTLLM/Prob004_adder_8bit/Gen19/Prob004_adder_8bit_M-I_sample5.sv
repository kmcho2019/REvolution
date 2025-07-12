// Define a module for a full adder
module full_adder(
    input   a,
    input   b,
    input   cin,
    output  sum,
    output  cout
);
    
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
    
endmodule

// Define a module for a 4-bit carry-lookahead adder
module adder_4bit_cla(
    input   [3:0] a,
    input   [3:0] b,
    input       cin,
    output  [3:0] sum,
    output      cout
);
    
    wire g0, g1, g2, g3, p0, p1, p2, p3, c1, c2, c3;
    
    assign g0 = a[0] & b[0];
    assign p0 = a[0] | b[0];
    assign c1 = g0 | (p0 & cin);
    assign sum[0] = a[0] ^ b[0] ^ cin;
    
    assign g1 = a[1] & b[1];
    assign p1 = a[1] | b[1];
    assign c2 = g1 | (p1 & c1);
    assign sum[1] = a[1] ^ b[1] ^ c1;
    
    assign g2 = a[2] & b[2];
    assign p2 = a[2] | b[2];
    assign c3 = g2 | (p2 & c2);
    assign sum[2] = a[2] ^ b[2] ^ c2;
    
    assign g3 = a[3] & b[3];
    assign p3 = a[3] | b[3];
    assign cout = g3 | (p3 & c3);
    assign sum[3] = a[3] ^ b[3] ^ c3;
    
endmodule

// Define the 8-bit adder module using the 4-bit carry-lookahead adder
module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);
    
    wire c4;
    
    adder_4bit_cla u0 (.a(a[3:0]), .b(b[3:0]), .cin(cin), .sum(sum[3:0]), .cout(c4));
    adder_4bit_cla u1 (.a(a[7:4]), .b(b[7:4]), .cin(c4), .sum(sum[7:4]), .cout(cout));
    
endmodule
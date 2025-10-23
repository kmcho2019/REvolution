module adder_4bit(
    input   [3:0] a,
    input   [3:0] b,
    input       cin,
    output  [3:0] sum,
    output      cout
);
    
    assign sum[0] = a[0] ^ b[0] ^ cin;
    assign sum[1] = a[1] ^ b[1] ^ (a[0] & b[0]) ^ (a[0] & cin) ^ (b[0] & cin);
    assign sum[2] = a[2] ^ b[2] ^ (a[1] & b[1]) ^ (a[1] & (a[0] & b[0])) ^ (a[1] & (a[0] & cin)) ^ (a[1] & (b[0] & cin)) ^ (b[1] & (a[0] & b[0])) ^ (b[1] & (a[0] & cin)) ^ (b[1] & (b[0] & cin));
    assign sum[3] = a[3] ^ b[3] ^ (a[2] & b[2]) ^ (a[2] & (a[1] & b[1])) ^ (a[2] & (a[1] & (a[0] & b[0]))) ^ (a[2] & (a[1] & (a[0] & cin))) ^ (a[2] & (a[1] & (b[0] & cin))) ^ (a[2] & (b[1] & (a[0] & b[0]))) ^ (a[2] & (b[1] & (a[0] & cin))) ^ (a[2] & (b[1] & (b[0] & cin))) ^ (b[2] & (a[1] & b[1])) ^ (b[2] & (a[1] & (a[0] & b[0]))) ^ (b[2] & (a[1] & (a[0] & cin))) ^ (b[2] & (a[1] & (b[0] & cin))) ^ (b[2] & (b[1] & (a[0] & b[0]))) ^ (b[2] & (b[1] & (a[0] & cin))) ^ (b[2] & (b[1] & (b[0] & cin)));
    assign cout = (a[3] & b[3]) | (a[3] & (a[2] & b[2])) | (a[3] & (a[2] & (a[1] & b[1]))) | (a[3] & (a[2] & (a[1] & (a[0] & b[0]))) | (b[3] & (a[2] & b[2])) | (b[3] & (a[2] & (a[1] & b[1]))) | (b[3] & (a[2] & (a[1] & (a[0] & b[0]))));
    
endmodule

module prefix_tree(
    input   [7:0] a,
    input   [7:0] b,
    output  [7:0] carry
);
    
    assign carry[0] = a[0] & b[0];
    assign carry[1] = (a[1] & b[1]) | (a[1] & carry[0]) | (b[1] & carry[0]);
    assign carry[2] = (a[2] & b[2]) | (a[2] & carry[1]) | (b[2] & carry[1]);
    assign carry[3] = (a[3] & b[3]) | (a[3] & carry[2]) | (b[3] & carry[2]);
    assign carry[4] = (a[4] & b[4]) | (a[4] & carry[3]) | (b[4] & carry[3]);
    assign carry[5] = (a[5] & b[5]) | (a[5] & carry[4]) | (b[5] & carry[4]);
    assign carry[6] = (a[6] & b[6]) | (a[6] & carry[5]) | (b[6] & carry[5]);
    assign carry[7] = (a[7] & b[7]) | (a[7] & carry[6]) | (b[7] & carry[6]);
    
endmodule

module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);
    
    wire [3:0] sum1, sum2;
    wire cout1, cout2;
    
    adder_4bit u0 (.a(a[3:0]), .b(b[3:0]), .cin(cin), .sum(sum1), .cout(cout1));
    adder_4bit u1 (.a(a[7:4]), .b(b[7:4]), .cin(cout1), .sum(sum2), .cout(cout2));
    
    assign sum[3:0] = sum1;
    assign sum[7:4] = sum2;
    assign cout = cout2;
    
endmodule
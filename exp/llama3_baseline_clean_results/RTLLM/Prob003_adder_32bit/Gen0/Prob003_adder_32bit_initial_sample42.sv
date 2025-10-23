// 1-bit full adder
module full_adder(a, b, cin, sum, cout);
    input a, b, cin;
    output sum, cout;
    
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// 4-bit carry-lookahead adder
module cla_4bit(a, b, cin, sum, cout);
    input [3:0] a, b;
    input cin;
    output [3:0] sum;
    output cout;
    
    wire p, g;
    wire [2:0] c;
    
    assign p = a[0] ^ b[0];
    assign g = a[0] & b[0];
    assign c[0] = (a[0] & b[0]) | (a[0] & cin) | (b[0] & cin);
    
    full_adder fa0(a[0], b[0], cin, sum[0], c[0]);
    
    for (genvar i = 1; i < 4; i++) begin
        assign p = a[i] ^ b[i];
        assign g = a[i] & b[i];
        assign c[i-1] = g | (p & c[i-1]);
        
        full_adder fa1(a[i], b[i], c[i-1], sum[i], c[i]);
    end
    
    assign cout = c[3];
endmodule

// 16-bit carry-lookahead adder
module cla_16bit(a, b, cin, sum, cout);
    input [15:0] a, b;
    input cin;
    output [15:0] sum;
    output cout;
    
    wire [3:0] p, g;
    wire [3:0] c;
    
    cla_4bit cla0(a[3:0], b[3:0], cin, sum[3:0], c[0]);
    cla_4bit cla1(a[7:4], b[7:4], c[0], sum[7:4], c[1]);
    cla_4bit cla2(a[11:8], b[11:8], c[1], sum[11:8], c[2]);
    cla_4bit cla3(a[15:12], b[15:12], c[2], sum[15:12], c[3]);
    
    assign cout = c[3];
endmodule

// 32-bit carry-lookahead adder
module adder_32bit(A, B, S, C32);
    input [31:1] A, B;
    output [31:1] S;
    output C32;
    
    wire c16;
    
    cla_16bit cla0(A[15:1], B[15:1], 1'b0, S[15:1], c16);
    cla_16bit cla1(A[31:16], B[31:16], c16, S[31:16], C32);
endmodule
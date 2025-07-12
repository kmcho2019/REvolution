// Define the full adder module
module full_adder(
    input  a,  // input bit
    input  b,  // input bit
    input  cin,  // carry-in
    output sum,  // sum bit
    output cout  // carry-out
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// Define the carry-lookahead adder module
module cla_adder(
    input  [3:0] a,  
    input  [3:0] b,  
    input  cin,  
    output [3:0] sum,  
    output cout  
);
    wire [3:0] p, g;
    wire c1, c2, c3;
    
    assign p[0] = a[0] ^ b[0];
    assign g[0] = a[0] & b[0];
    assign c1 = g[0] | (p[0] & cin);
    
    assign p[1] = a[1] ^ b[1];
    assign g[1] = a[1] & b[1];
    assign c2 = g[1] | (p[1] & c1);
    
    assign p[2] = a[2] ^ b[2];
    assign g[2] = a[2] & b[2];
    assign c3 = g[2] | (p[2] & c2);
    
    assign sum[0] = p[0] ^ cin;
    assign sum[1] = p[1] ^ c1;
    assign sum[2] = p[2] ^ c2;
    assign sum[3] = a[3] ^ b[3] ^ c3;
    assign cout = g[3] | (p[3] & c3);
endmodule

// Define the hybrid adder module
module hybrid_adder(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] sum,  
    output cout  
);
    wire [3:0] sum_low;
    wire cout_low;
    wire [3:0] sum_high;
    wire cout_high;
    
    // Lower bits (0-3) using ripple-carry adder
    full_adder bit0(.a(a[0]), .b(b[0]), .cin(1'b0), .sum(sum[0]), .cout(cout));
    full_adder bit1(.a(a[1]), .b(b[1]), .cin(cout), .sum(sum[1]), .cout(cout));
    full_adder bit2(.a(a[2]), .b(b[2]), .cin(cout), .sum(sum[2]), .cout(cout));
    full_adder bit3(.a(a[3]), .b(b[3]), .cin(cout), .sum(sum[3]), .cout(cout_low));
    
    // Higher bits (4-7) using carry-lookahead adder
    cla_adder cla(.a(a[4:1]), .b(b[4:1]), .cin(cout_low), .sum(sum_high), .cout(cout_high));
    
    // Assign the high bits of the sum
    assign sum[4] = sum_high[0];
    assign sum[5] = sum_high[1];
    assign sum[6] = sum_high[2];
    assign sum[7] = sum_high[3];
    
    // Assign the final carry-out
    assign cout = cout_high;
endmodule

// Define the overflow detection module
module overflow_detector(
    input  [7:0] a,  
    input  [7:0] b,  
    input  [7:0] sum,  
    output      overflow  
);
    assign overflow = (a[7] == b[7] && a[7] != sum[7]);
endmodule

// TopModule that integrates the hybrid adder and overflow detection
module TopModule(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] s,  
    output      overflow  
);
    wire [7:0] sum;
    wire cout;
    
    hybrid_adder ha(.a(a), .b(b), .sum(sum), .cout(cout));
    overflow_detector od(.a(a), .b(b), .sum(sum), .overflow(overflow));
    
    assign s = sum;
endmodule
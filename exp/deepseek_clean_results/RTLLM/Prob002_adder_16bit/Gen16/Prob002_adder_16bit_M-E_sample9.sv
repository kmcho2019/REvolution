module cla_4bit (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);
    // Generate and propagate terms
    wire [3:0] g = a & b;
    wire [3:0] p = a ^ b;
    
    // Group carry computation
    wire [3:0] c;
    assign c[0] = cin;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | 
                 (p[2] & p[1] & p[0] & c[0]);
    
    // Sum and final carry
    assign sum = p ^ c[3:0];
    assign cout = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | 
                 (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c[0]);
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    // First 4-bit CLA (bits 3:0)
    wire [3:0] sum0;
    wire cout0;
    cla_4bit cla0 (.a(a[3:0]), .b(b[3:0]), .cin(Cin), .sum(sum0), .cout(cout0));
    
    // Carry-select blocks for remaining bits
    wire [3:0] sum1_0, sum1_1, sum2_0, sum2_1, sum3_0, sum3_1;
    wire cout1_0, cout1_1, cout2_0, cout2_1, cout3_0, cout3_1;
    
    // Block 1 (bits 7:4) - both carry cases
    cla_4bit cla1_0 (.a(a[7:4]), .b(b[7:4]), .cin(1'b0), .sum(sum1_0), .cout(cout1_0));
    cla_4bit cla1_1 (.a(a[7:4]), .b(b[7:4]), .cin(1'b1), .sum(sum1_1), .cout(cout1_1));
    
    // Block 2 (bits 11:8) - both carry cases
    cla_4bit cla2_0 (.a(a[11:8]), .b(b[11:8]), .cin(1'b0), .sum(sum2_0), .cout(cout2_0));
    cla_4bit cla2_1 (.a(a[11:8]), .b(b[11:8]), .cin(1'b1), .sum(sum2_1), .cout(cout2_1));
    
    // Block 3 (bits 15:12) - both carry cases
    cla_4bit cla3_0 (.a(a[15:12]), .b(b[15:12]), .cin(1'b0), .sum(sum3_0), .cout(cout3_0));
    cla_4bit cla3_1 (.a(a[15:12]), .b(b[15:12]), .cin(1'b1), .sum(sum3_1), .cout(cout3_1));
    
    // Carry-select muxes
    wire sel1 = cout0;
    wire [3:0] sum1 = sel1 ? sum1_1 : sum1_0;
    wire cout1 = sel1 ? cout1_1 : cout1_0;
    
    wire sel2 = cout1;
    wire [3:0] sum2 = sel2 ? sum2_1 : sum2_0;
    wire cout2 = sel2 ? cout2_1 : cout2_0;
    
    wire sel3 = cout2;
    wire [3:0] sum3 = sel3 ? sum3_1 : sum3_0;
    wire cout3 = sel3 ? cout3_1 : cout3_0;
    
    // Final output
    assign y = {sum3, sum2, sum1, sum0};
    assign Co = cout3;
endmodule
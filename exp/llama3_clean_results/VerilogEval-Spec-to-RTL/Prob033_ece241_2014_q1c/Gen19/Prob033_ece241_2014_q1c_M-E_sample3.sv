// Define the half adder module
module half_adder(
    input  a,  // input bit
    input  b,  // input bit
    output sum,  // sum bit
    output cout  // carry-out
);
    assign sum = a ^ b;
    assign cout = a & b;
endmodule

// Define the full adder module
module full_adder(
    input  a,  // input bit
    input  b,  // input bit
    input  cin,  // carry-in
    output sum,  // sum bit
    output cout  // carry-out
);
    wire p, g;
    half_adder ha1(
       .a(a),
       .b(b),
       .sum(p),
       .cout(g)
    );
    half_adder ha2(
       .a(p),
       .b(cin),
       .sum(sum),
       .cout(cout)
    );
endmodule

// Define the binary tree adder module
module binary_tree_adder(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] sum  
);
    // Level 1: Add adjacent bits
    wire [3:0] sum_l1;
    wire [3:0] cout_l1;
    genvar i;
    generate
        for (i = 0; i < 4; i++) begin
            full_adder fa(
               .a(a[i*2]),
               .b(a[i*2+1]),
               .cin(b[i*2]),
               .sum(sum_l1[i]),
               .cout(cout_l1[i])
            );
        end
    endgenerate

    // Level 2: Add results from Level 1
    wire [1:0] sum_l2;
    wire [1:0] cout_l2;
    generate
        for (i = 0; i < 2; i++) begin
            full_adder fa(
               .a(sum_l1[i*2]),
               .b(sum_l1[i*2+1]),
               .cin(cout_l1[i*2]),
               .sum(sum_l2[i]),
               .cout(cout_l2[i])
            );
        end
    endgenerate

    // Level 3: Add results from Level 2
    wire sum_l3;
    wire cout_l3;
    full_adder fa(
       .a(sum_l2[0]),
       .b(sum_l2[1]),
       .cin(cout_l2[0]),
       .sum(sum_l3),
       .cout(cout_l3)
    );

    // Assign final sum
    assign sum[0] = sum_l3;
    assign sum[1] = cout_l3;
    assign sum[2] = cout_l2[1];
    assign sum[3] = cout_l2[0];
    assign sum[4] = cout_l1[3];
    assign sum[5] = cout_l1[2];
    assign sum[6] = cout_l1[1];
    assign sum[7] = cout_l1[0];
endmodule

// Define the overflow detection module
module overflow_detection(
    input  [7:0] a,  
    input  [7:0] b,  
    input  [7:0] sum,  
    output      overflow  
);
    assign overflow = (a[7] == b[7] && a[7]!= sum[7]);
endmodule

// TopModule that integrates the binary tree adder and overflow detection
module TopModule(
    input  [7:0] a,  
    input  [7:0] b,  
    output [7:0] s,  
    output      overflow  
);
    wire [7:0] sum;
    binary_tree_adder bta(
       .a(a),
       .b(b),
       .sum(sum)
    );
    overflow_detection od(
       .a(a),
       .b(b),
       .sum(sum),
       .overflow(overflow)
    );
    assign s = sum;
endmodule
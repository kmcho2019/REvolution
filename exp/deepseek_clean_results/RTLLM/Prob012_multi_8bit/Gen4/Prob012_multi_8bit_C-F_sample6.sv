module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Generate all partial products with operand isolation
    wire [15:0] pp [7:0];
    generate
        genvar i;
        for (i=0; i<8; i=i+1) begin : pp_gen
            assign pp[i] = B[i] ? ({{(8-i){1'b0}}, A, {i{1'b0}}) : 16'b0;
        end
    endgenerate

    // First level compression (4:2)
    wire [15:0] s1, c1;
    assign {c1, s1} = pp[0] + pp[1] + pp[2] + pp[3];
    
    // Second level compression (4:2)
    wire [15:0] s2, c2;
    assign {c2, s2} = pp[4] + pp[5] + pp[6] + pp[7];
    
    // Third level compression (3:2 CSA)
    wire [15:0] sum3, carry3;
    csa csa_level3 (
        .a(s1),
        .b({c1[14:0], 1'b0}),
        .c(s2),
        .sum(sum3),
        .carry(carry3)
    );
    
    // Final addition (carry-select)
    wire [15:0] carry_shifted = {carry3[14:0], 1'b0};
    wire [15:0] c2_shifted = {c2[14:0], 1'b0};
    
    carry_select_adder #(16) final_adder (
        .a(sum3),
        .b(carry_shifted + c2_shifted),
        .sum(product)
    );

endmodule

// Carry-Save Adder module
module csa (
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    output [15:0] sum,
    output [15:0] carry
);
    assign sum = a ^ b ^ c;
    assign carry = (a & b) | (a & c) | (b & c);
endmodule

// Parameterized Carry-Select Adder
module carry_select_adder #(
    parameter WIDTH = 16
) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [WIDTH-1:0] sum
);
    // Implementation of carry-select adder
    wire [WIDTH-1:0] sum0, sum1;
    wire [WIDTH/2-1:0] carry;
    
    // Lower half - ripple carry
    assign {carry[0], sum[3:0]} = a[3:0] + b[3:0];
    
    // Middle sections
    generate
        genvar i;
        for (i=1; i<WIDTH/4; i=i+1) begin : csa_gen
            assign sum0[4*i+3:4*i] = a[4*i+3:4*i] + b[4*i+3:4*i];
            assign sum1[4*i+3:4*i] = a[4*i+3:4*i] + b[4*i+3:4*i] + 1'b1;
            assign sum[4*i+3:4*i] = carry[i-1] ? sum1[4*i+3:4*i] : sum0[4*i+3:4*i];
            assign carry[i] = carry[i-1] ? |sum1[4*i+3:4*i] : |sum0[4*i+3:4*i];
        end
    endgenerate
    
    // Upper bits
    assign sum[WIDTH-1:WIDTH-4] = carry[WIDTH/4-1] ? 
                                 (a[WIDTH-1:WIDTH-4] + b[WIDTH-1:WIDTH-4] + 1'b1) :
                                 (a[WIDTH-1:WIDTH-4] + b[WIDTH-1:WIDTH-4]);
endmodule
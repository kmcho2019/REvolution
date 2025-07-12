module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    localparam WIDTH = 8;
    localparam PP_COUNT = WIDTH;
    localparam PRODUCT_WIDTH = 2*WIDTH;

    // Generate partial products conditionally with clean syntax
    wire [PRODUCT_WIDTH-1:0] pp [PP_COUNT-1:0];
    genvar i;
    generate
        for (i = 0; i < PP_COUNT; i = i + 1) begin : gen_pp
            assign pp[i] = B[i] ? ({{(PRODUCT_WIDTH-WIDTH){1'b0}}, A} << i) : 
                                      {(PRODUCT_WIDTH){1'b0}};
        end
    endgenerate

    // First level CSA reduction - process 3 groups in parallel
    wire [PRODUCT_WIDTH-1:0] sum1_0, carry1_0;
    wire [PRODUCT_WIDTH-1:0] sum1_1, carry1_1;
    wire [PRODUCT_WIDTH-1:0] sum1_2, carry1_2;
    
    csa #(.WIDTH(PRODUCT_WIDTH)) csa_level1_0 (pp[0], pp[1], pp[2], sum1_0, carry1_0);
    csa #(.WIDTH(PRODUCT_WIDTH)) csa_level1_1 (pp[3], pp[4], pp[5], sum1_1, carry1_1);
    assign sum1_2 = pp[6];
    assign carry1_2 = pp[7];

    // Second level CSA reduction
    wire [PRODUCT_WIDTH-1:0] sum2, carry2;
    wire [PRODUCT_WIDTH-1:0] shifted_carry1_0 = {carry1_0[PRODUCT_WIDTH-2:0], 1'b0};
    wire [PRODUCT_WIDTH-1:0] shifted_carry1_1 = {carry1_1[PRODUCT_WIDTH-2:0], 1'b0};
    
    csa #(.WIDTH(PRODUCT_WIDTH)) csa_level2 (
        sum1_0, 
        shifted_carry1_0, 
        sum1_1, 
        sum2, 
        carry2
    );

    // Third level combines remaining terms
    wire [PRODUCT_WIDTH-1:0] sum3, carry3;
    csa #(.WIDTH(PRODUCT_WIDTH)) csa_level3 (
        sum2, 
        shifted_carry1_1, 
        sum1_2, 
        sum3, 
        carry3
    );

    // Final addition with optimized adder
    wire [PRODUCT_WIDTH-1:0] final_carry_in = 
        {carry2[PRODUCT_WIDTH-2:0], 1'b0} + 
        {carry3[PRODUCT_WIDTH-2:0], 1'b0} + 
        carry1_2;
    
    assign product = sum3 + final_carry_in;

endmodule

// Parameterized Carry-Save Adder module
module csa #(
    parameter WIDTH = 16
) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input [WIDTH-1:0] c,
    output [WIDTH-1:0] sum,
    output [WIDTH-1:0] carry
);
    assign sum = a ^ b ^ c;
    assign carry = (a & b) | (a & c) | (b & c);
endmodule
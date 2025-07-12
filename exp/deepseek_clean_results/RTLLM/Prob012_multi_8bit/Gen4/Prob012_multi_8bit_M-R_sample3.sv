module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Parameterized width for better reusability
    parameter WIDTH = 8;
    
    // Array to store partial products
    wire [15:0] partial_products [WIDTH-1:0];
    
    // Generate partial products
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : gen_partial
            // Create shifted versions of A (with zero extension)
            assign partial_products[i] = B[i] ? {{(16-WIDTH){1'b0}, A} << i : 16'b0;
        end
    endgenerate
    
    // Adder tree implementation
    wire [15:0] sum_stage1 [3:0];
    wire [15:0] sum_stage2 [1:0];
    
    // First stage of addition
    assign sum_stage1[0] = partial_products[0] + partial_products[1];
    assign sum_stage1[1] = partial_products[2] + partial_products[3];
    assign sum_stage1[2] = partial_products[4] + partial_products[5];
    assign sum_stage1[3] = partial_products[6] + partial_products[7];
    
    // Second stage of addition
    assign sum_stage2[0] = sum_stage1[0] + sum_stage1[1];
    assign sum_stage2[1] = sum_stage1[2] + sum_stage1[3];
    
    // Final addition
    assign product = sum_stage2[0] + sum_stage2[1];

endmodule
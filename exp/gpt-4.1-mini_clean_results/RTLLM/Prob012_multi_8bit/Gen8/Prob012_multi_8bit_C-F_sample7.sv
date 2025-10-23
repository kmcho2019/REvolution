module multi_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire [15:0] product
);

    wire [15:0] partial_products [7:0];

    genvar i;

    // Explicitly build shifted partial products to ensure synthesis of wiring shifts, not logic shifters.
    // Each partial product is A masked with B[i] and shifted left by i bits via wiring.
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
            wire [15:0] shifted;
            
            // Zero-extend A to 16 bits
            wire [15:0] A_ext = {8'd0, A};

            // Build shifted version of A_ext by concatenating zeros and A_ext bits, avoiding shift operator
            if (i == 0) begin
                assign shifted = A_ext;
            end else begin
                // For shift left by i bits:
                // Upper bits = A_ext[15-i:0]
                // Lower i bits = zero
                assign shifted = {A_ext[15 - i:0], {i{1'b0}}};
            end
            
            // Mask partial product with B[i]
            assign partial_products[i] = B[i] ? shifted : 16'd0;
        end
    endgenerate

    // Balanced binary tree summation of partial products
    wire [15:0] sum_level1 [3:0];
    wire [15:0] sum_level2 [1:0];
    wire [15:0] sum_level3;

    // Level 1: sum pairs of partial_products
    assign sum_level1[0] = partial_products[0] + partial_products[1];
    assign sum_level1[1] = partial_products[2] + partial_products[3];
    assign sum_level1[2] = partial_products[4] + partial_products[5];
    assign sum_level1[3] = partial_products[6] + partial_products[7];

    // Level 2: sum pairs of sums from level 1
    assign sum_level2[0] = sum_level1[0] + sum_level1[1];
    assign sum_level2[1] = sum_level1[2] + sum_level1[3];

    // Level 3: final sum to produce the product
    assign sum_level3 = sum_level2[0] + sum_level2[1];

    assign product = sum_level3;

endmodule
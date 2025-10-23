module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Generate and shift partial products
    wire [15:0] pp [7:0];
    
    generate
        genvar i;
        for (i=0; i<8; i=i+1) begin : pp_gen
            assign pp[i] = B[i] ? (A << i) : 16'b0;
        end
    endgenerate

    // Accumulate partial products in binary tree fashion
    wire [15:0] sum_level1 [3:0];
    assign sum_level1[0] = pp[0] + pp[1];
    assign sum_level1[1] = pp[2] + pp[3];
    assign sum_level1[2] = pp[4] + pp[5];
    assign sum_level1[3] = pp[6] + pp[7];

    wire [15:0] sum_level2 [1:0];
    assign sum_level2[0] = sum_level1[0] + sum_level1[1];
    assign sum_level2[1] = sum_level1[2] + sum_level1[3];

    // Final sum
    assign product = sum_level2[0] + sum_level2[1];

endmodule
module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Partial products array
    wire [15:0] pp [7:0];
    
    // Generate all partial products
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = ({8'b0, A} << i) & {16{B[i]}};
        end
    endgenerate

    // First level of reduction (parallel adds)
    wire [15:0] sum_l1 [3:0];
    assign sum_l1[0] = pp[0] + pp[1];
    assign sum_l1[1] = pp[2] + pp[3];
    assign sum_l1[2] = pp[4] + pp[5];
    assign sum_l1[3] = pp[6] + pp[7];

    // Second level of reduction
    wire [15:0] sum_l2 [1:0];
    assign sum_l2[0] = sum_l1[0] + sum_l1[1];
    assign sum_l2[1] = sum_l1[2] + sum_l1[3];

    // Final sum
    assign product = sum_l2[0] + sum_l2[1];

endmodule
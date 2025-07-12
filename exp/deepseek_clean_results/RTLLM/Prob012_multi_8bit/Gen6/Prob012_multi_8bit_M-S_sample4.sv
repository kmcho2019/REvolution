module multi_8bit (
    input wire [7:0] A,
    input wire [7:0] B,
    output wire [15:0] product
);

    wire [15:0] partial_products [0:7];
    
    generate
        genvar i;
        for (i = 0; i < 8; i = i + 1) begin : gen_partial
            assign partial_products[i] = B[i] ? (A << i) : 16'b0;
        end
    endgenerate

    assign product = partial_products[0] + partial_products[1] + partial_products[2] + 
                    partial_products[3] + partial_products[4] + partial_products[5] + 
                    partial_products[6] + partial_products[7];

endmodule
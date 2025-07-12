module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Parameter for bit width (makes design more reusable)
    parameter WIDTH = 8;
    
    // Extended multiplicand with proper zero padding
    wire [15:0] A_ext = {{(16-WIDTH){1'b0}}, A};
    
    // Array to hold all partial products
    wire [15:0] pp [WIDTH-1:0];
    
    // Generate partial products
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : PARTIAL_PROD
            assign pp[i] = B[i] ? (A_ext << i) : 16'b0;
        end
    endgenerate
    
    // Reduction tree for summing partial products
    assign product = pp[0] + pp[1] + pp[2] + pp[3] + 
                    pp[4] + pp[5] + pp[6] + pp[7];

endmodule
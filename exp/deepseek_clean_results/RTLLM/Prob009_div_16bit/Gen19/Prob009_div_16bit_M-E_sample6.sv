module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    // Binary search division implementation
    wire [15:0] partial_quotient [0:15];
    wire [15:0] partial_product [0:15];
    wire [15:0] partial_remainder [0:15];
    wire [15:0] next_remainder [0:15];
    
    // Initialize
    assign partial_remainder[15] = A;
    
    genvar i;
    generate
        for (i = 15; i >= 0; i = i - 1) begin : div_tree
            // Tentative quotient with current bit set
            assign partial_quotient[i] = (1 << i);
            
            // Calculate tentative product
            assign partial_product[i] = B * partial_quotient[i];
            
            // Compare and determine actual quotient bit
            assign result[i] = (partial_product[i] <= partial_remainder[i]);
            
            // Calculate next remainder
            assign next_remainder[i] = result[i] ? 
                                      (partial_remainder[i] - partial_product[i]) : 
                                      partial_remainder[i];
            
            // Propagate remainder to next stage
            if (i > 0) begin
                assign partial_remainder[i-1] = next_remainder[i];
            end
        end
    endgenerate
    
    // Final remainder
    assign odd = next_remainder[0];

endmodule
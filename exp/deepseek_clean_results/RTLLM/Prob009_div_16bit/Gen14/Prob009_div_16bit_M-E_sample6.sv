module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    // Array of shifted divisors (B << 0 to B << 15)
    wire [23:0] shifted_B [0:15];
    generate
        genvar i;
        for (i = 0; i < 16; i = i + 1) begin : shift_gen
            assign shifted_B[i] = B << i;
        end
    endgenerate

    // Binary search for each quotient bit
    wire [15:0] partial_remainder [0:16];
    assign partial_remainder[0] = A;
    
    generate
        for (i = 15; i >= 0; i = i - 1) begin : div_tree
            // Compare current remainder with shifted divisor
            wire can_subtract = (partial_remainder[15-i] >= shifted_B[i]);
            
            // Conditional subtraction
            assign partial_remainder[16-i] = can_subtract ? 
                (partial_remainder[15-i] - shifted_B[i]) : 
                partial_remainder[15-i];
            
            // Set quotient bit
            assign result[i] = can_subtract;
        end
    endgenerate

    // Final remainder
    assign odd = partial_remainder[16];

endmodule
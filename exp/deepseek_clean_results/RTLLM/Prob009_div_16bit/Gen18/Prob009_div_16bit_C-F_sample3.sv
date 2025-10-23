module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    // Intermediate remainders for each stage (8 bits)
    wire [7:0] rem [0:15];
    
    // First stage (MSB)
    wire [8:0] first_cmp = {1'b0, A[15]};
    assign rem[15] = (first_cmp >= {1'b0, B}) ? (first_cmp - B) : first_cmp[7:0];
    assign result[15] = (first_cmp >= {1'b0, B});
    
    // Generate remaining stages
    genvar i;
    generate
        for (i = 14; i >= 0; i = i - 1) begin : div_stages
            wire [8:0] current_cmp = {rem[i+1], A[i]};
            assign rem[i] = (current_cmp >= {1'b0, B}) ? 
                          (current_cmp - B) : current_cmp[7:0];
            assign result[i] = (current_cmp >= {1'b0, B});
        end
    endgenerate
    
    // Final remainder output with zero-division check
    assign odd = (B == 8'b0) ? 8'b0 : rem[0];

endmodule
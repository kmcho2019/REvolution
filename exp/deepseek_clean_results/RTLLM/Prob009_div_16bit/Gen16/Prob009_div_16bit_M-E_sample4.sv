module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    // Special case: division by zero
    wire zero_divisor = (B == 8'b0);
    
    // Binary search ranges for quotient
    wire [15:0] candidate [0:15];
    wire [15:0] product [0:15];
    wire [15:0] diff [0:15];
    wire [15:0] valid;
    
    // Generate all possible quotient candidates
    generate
        genvar i;
        for (i = 0; i < 16; i = i + 1) begin : candidates
            // Create binary search pattern (MSB first)
            localparam [15:0] mask = (16'b1 << (15-i));
            assign candidate[i] = (zero_divisor) ? 16'b0 : mask;
            assign product[i] = candidate[i] * B;
            assign diff[i] = A - product[i];
            assign valid[i] = ~diff[i][15];  // Check if difference is positive
        end
    endgenerate
    
    // Priority encoder to select highest valid quotient
    wire [15:0] quotient;
    assign quotient[15] = valid[15];
    assign quotient[14] = valid[14] & ~valid[15];
    assign quotient[13] = valid[13] & ~(|valid[15:14]);
    assign quotient[12] = valid[12] & ~(|valid[15:12]);
    assign quotient[11] = valid[11] & ~(|valid[15:10]);
    assign quotient[10] = valid[10] & ~(|valid[15:10]);
    assign quotient[9]  = valid[9]  & ~(|valid[15:8]);
    assign quotient[8]  = valid[8]  & ~(|valid[15:8]);
    assign quotient[7]  = valid[7]  & ~(|valid[15:6]);
    assign quotient[6]  = valid[6]  & ~(|valid[15:6]);
    assign quotient[5]  = valid[5]  & ~(|valid[15:4]);
    assign quotient[4]  = valid[4]  & ~(|valid[15:4]);
    assign quotient[3]  = valid[3]  & ~(|valid[15:2]);
    assign quotient[2]  = valid[2]  & ~(|valid[15:2]);
    assign quotient[1]  = valid[1]  & ~valid[0];
    assign quotient[0]  = valid[0]  & ~(|valid[15:1]);
    
    // Calculate final quotient and remainder
    wire [15:0] final_quotient;
    wire [15:0] final_product;
    wire [15:0] final_diff;
    
    assign final_quotient = (zero_divisor) ? 16'b0 : 
                          (quotient[15] ? candidate[15] :
                          quotient[14] ? candidate[14] :
                          quotient[13] ? candidate[13] :
                          quotient[12] ? candidate[12] :
                          quotient[11] ? candidate[11] :
                          quotient[10] ? candidate[10] :
                          quotient[9]  ? candidate[9]  :
                          quotient[8]  ? candidate[8]  :
                          quotient[7]  ? candidate[7]  :
                          quotient[6]  ? candidate[6]  :
                          quotient[5]  ? candidate[5]  :
                          quotient[4]  ? candidate[4]  :
                          quotient[3]  ? candidate[3]  :
                          quotient[2]  ? candidate[2]  :
                          quotient[1]  ? candidate[1]  :
                          candidate[0]);
    
    assign final_product = final_quotient * B;
    assign final_diff = A - final_product;
    
    // Output assignments
    assign result = final_quotient;
    assign odd = (zero_divisor) ? A[7:0] : final_diff[7:0];

endmodule
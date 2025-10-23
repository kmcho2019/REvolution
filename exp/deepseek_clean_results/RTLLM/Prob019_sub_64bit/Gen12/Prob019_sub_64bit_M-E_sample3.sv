module sub_64bit (
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);

    // Block parameters
    localparam BLOCK_SIZE = 8;
    localparam NUM_BLOCKS = 64/BLOCK_SIZE;
    
    wire [NUM_BLOCKS:0] block_borrow;
    wire [NUM_BLOCKS-1:0] block_overflow;
    
    assign block_borrow[0] = 1'b0; // No initial borrow
    
    genvar i;
    generate
        for (i = 0; i < NUM_BLOCKS; i = i + 1) begin : sub_block
            // Current block indices
            localparam HI = (i+1)*BLOCK_SIZE-1;
            localparam LO = i*BLOCK_SIZE;
            
            // Carry-select implementation
            wire [BLOCK_SIZE-1:0] res_borrow0, res_borrow1;
            wire [BLOCK_SIZE:0] borrow0, borrow1;
            
            // Compute both possible results (borrow-in 0 and 1)
            assign borrow0[0] = 1'b0;
            assign borrow1[0] = 1'b1;
            
            // Generate both possible subtractor chains
            genvar j;
            for (j = 0; j < BLOCK_SIZE; j = j + 1) begin : bit_sub
                assign res_borrow0[j] = A[LO+j] ^ B[LO+j] ^ borrow0[j];
                assign borrow0[j+1] = (~A[LO+j] & B[LO+j]) | 
                                     (~A[LO+j] & borrow0[j]) | 
                                     (B[LO+j] & borrow0[j]);
                
                assign res_borrow1[j] = A[LO+j] ^ B[LO+j] ^ borrow1[j];
                assign borrow1[j+1] = (~A[LO+j] & B[LO+j]) | 
                                     (~A[LO+j] & borrow1[j]) | 
                                     (B[LO+j] & borrow1[j]);
            end
            
            // Select correct result based on actual borrow-in
            assign result[HI:LO] = block_borrow[i] ? res_borrow1 : res_borrow0;
            assign block_borrow[i+1] = block_borrow[i] ? borrow1[BLOCK_SIZE] : borrow0[BLOCK_SIZE];
            
            // Early overflow detection per block
            wire block_sign_diff = A[HI] != B[HI];
            wire block_res_sign_diff = A[HI] != result[HI];
            assign block_overflow[i] = block_sign_diff && block_res_sign_diff;
        end
    endgenerate
    
    // Final overflow detection (OR of all block overflows)
    assign overflow = |block_overflow;
    
endmodule
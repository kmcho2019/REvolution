module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output logic signed [63:0] result,
    output logic overflow
);

    // Two's complement conversion
    wire [63:0] B_comp = ~B;
    wire [63:0] B_neg = B_comp + 1;  // Complete two's complement
    
    // Block parameters
    localparam BLOCK_SIZE = 8;
    localparam NUM_BLOCKS = 64/BLOCK_SIZE;
    
    // Block-level signals
    wire [NUM_BLOCKS-1:0] block_carry_out;
    wire [63:0] sum0 [NUM_BLOCKS]; // Sum assuming carry-in=0
    wire [63:0] sum1 [NUM_BLOCKS]; // Sum assuming carry-in=1
    wire [63:0] block_result [NUM_BLOCKS];
    
    // First block (special case for carry-in)
    sub_8bit_block #(.BLOCK_IDX(0)) block0 (
        .A(A[BLOCK_SIZE-1:0]),
        .B(B_neg[BLOCK_SIZE-1:0]),
        .cin(1'b1),  // +1 for two's complement
        .sum0(sum0[0][BLOCK_SIZE-1:0]),
        .sum1(sum1[0][BLOCK_SIZE-1:0]),
        .cout(block_carry_out[0])
    );
    
    assign block_result[0] = sum0[0]; // First block always uses cin=1
    
    // Generate remaining blocks
    genvar i;
    generate
        for (i = 1; i < NUM_BLOCKS; i = i + 1) begin : sub_blocks
            // Block computation (both carry scenarios)
            sub_8bit_block #(.BLOCK_IDX(i)) block (
                .A(A[i*BLOCK_SIZE +: BLOCK_SIZE]),
                .B(B_neg[i*BLOCK_SIZE +: BLOCK_SIZE]),
                .cin(1'b0),  // Will be selected later
                .sum0(sum0[i][i*BLOCK_SIZE +: BLOCK_SIZE]),
                .sum1(sum1[i][i*BLOCK_SIZE +: BLOCK_SIZE]),
                .cout(block_carry_out[i])
            );
            
            // Carry selection mux
            assign block_result[i] = block_carry_out[i-1] ? 
                                   sum1[i] : sum0[i];
        end
    endgenerate
    
    // Combine block results
    always_comb begin
        result = 64'b0;
        for (int j = 0; j < NUM_BLOCKS; j++) begin
            result = result | block_result[j];
        end
    end
    
    // Early overflow detection
    wire potential_overflow = (A[63] != B[63]);
    wire result_sign_mismatch = (A[63] != result[63]);
    
    always_comb begin
        overflow = potential_overflow & result_sign_mismatch;
    end

endmodule

// 8-bit conditional sum block
module sub_8bit_block #(parameter BLOCK_IDX = 0) (
    input [7:0] A,
    input [7:0] B,
    input cin,
    output [7:0] sum0,
    output [7:0] sum1,
    output cout
);
    
    // Compute both possible sums in parallel
    assign sum0 = A + B + 1'b0;
    assign sum1 = A + B + 1'b1;
    
    // Carry out selection
    assign cout = cin ? (A + B + 1'b1 > 8'hFF) : 
                         (A + B + 1'b0 > 8'hFF);
    
    // Power gating based on operand magnitude (for higher bits)
    generate
        if (BLOCK_IDX > 4) begin : power_gate
            // Enable logic only when operands require these bits
            wire block_active = (|A[63:BLOCK_IDX*8]) || (|B[63:BLOCK_IDX*8]);
            
            // Operand isolation
            assign sum0 = block_active ? sum0 : 8'b0;
            assign sum1 = block_active ? sum1 : 8'b0;
            assign cout = block_active ? cout : 1'b0;
        end
    endgenerate
endmodule
module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Early overflow prediction (computed in parallel with subtraction)
    wire A_sign = A[63];
    wire B_sign = B[63];
    wire potential_overflow = (A_sign ^ B_sign);
    
    // Segment subtraction units (8x 8-bit)
    wire [7:0] segment_result [0:7];
    wire [7:0] segment_carry [0:7];
    
    // First segment (no carry-in dependency)
    sub_8bit_segment seg0 (
        .A(A[7:0]),
        .B(B[7:0]),
        .cin(1'b1),  // +1 for two's complement
        .sum(segment_result[0]),
        .cout(segment_carry[0])
    );
    
    // Middle segments with carry-select
    genvar i;
    generate
        for (i=1; i<8; i=i+1) begin : SEGMENTS
            sub_8bit_segment seg (
                .A(A[(i*8)+7:i*8]),
                .B(B[(i*8)+7:i*8]),
                .cin(segment_carry[i-1]),
                .sum(segment_result[i]),
                .cout(segment_carry[i])
            );
        end
    endgenerate
    
    // Combine segment results
    assign result = {
        segment_result[7], segment_result[6], segment_result[5], segment_result[4],
        segment_result[3], segment_result[2], segment_result[1], segment_result[0]
    };
    
    // Final overflow determination
    wire result_sign = result[63];
    assign overflow = potential_overflow & (A_sign ^ result_sign);

endmodule

// 8-bit subtraction segment with carry-in
module sub_8bit_segment (
    input [7:0] A,
    input [7:0] B,
    input cin,
    output [7:0] sum,
    output cout
);
    wire [7:0] B_comp = ~B;
    wire [8:0] carry = {1'b0, cin};
    
    // Conditional sum adder implementation
    genvar i;
    for (i=0; i<8; i=i+1) begin
        wire p = A[i] ^ B_comp[i];
        wire g = A[i] & B_comp[i];
        
        assign carry[i+1] = g | (p & carry[i]);
        assign sum[i] = p ^ carry[i];
    end
    
    assign cout = carry[8];
endmodule
module fixed_point_subtractor #(
    parameter N = 32     // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Two's complement subtraction: a - b = a + (~b + 1)
    wire [N-1:0] b_comp = ~b + 1'b1;
    
    // Carry-select adder implementation (4-bit blocks)
    wire [N:0] carry;
    wire [N-1:0] sum;
    wire zero_flag;
    
    assign carry[0] = 1'b0;
    
    genvar i;
    generate
        for (i = 0; i < N; i = i + 4) begin : adder_blocks
            // Current block
            wire [3:0] a_block = a[i+:4];
            wire [3:0] b_block = b_comp[i+:4];
            wire cin_block = carry[i];
            
            // Compute both possible carry scenarios
            wire [3:0] sum0, sum1;
            wire cout0, cout1;
            
            // Carry=0 case
            {cout0, sum0} = a_block + b_block + 1'b0;
            
            // Carry=1 case
            {cout1, sum1} = a_block + b_block + 1'b1;
            
            // Select correct result
            assign sum[i+:4] = cin_block ? sum1 : sum0;
            assign carry[i+4] = cin_block ? cout1 : cout0;
        end
    endgenerate
    
    // Zero detection (combinational reduction OR)
    assign zero_flag = ~(|sum);
    
    // Final result assignment
    assign c = zero_flag ? {N{1'b0}} : sum;

endmodule
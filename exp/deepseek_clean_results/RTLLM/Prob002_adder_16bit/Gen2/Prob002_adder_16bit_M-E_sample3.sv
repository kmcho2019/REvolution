module adder_4bit (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout,
    output block_propagate
);
    wire [3:0] p, g;
    wire [4:0] c;
    
    assign c[0] = cin;
    
    // Generate propagate and generate signals
    assign p = a ^ b;
    assign g = a & b;
    
    // Ripple carry within the 4-bit block
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);
    
    assign sum = p ^ c[3:0];
    assign cout = c[4];
    
    // Block propagate signal for carry-skip
    assign block_propagate = &p;
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire [3:0] carry0, carry1;
    wire [3:0] sum0, sum1;
    wire [3:0] block_propagate;
    wire [3:0] carry_skip;
    
    // First stage - compute both possible sums (carry0=0, carry1=1)
    adder_4bit block0_0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(1'b0),
        .sum(sum0[3:0]),
        .cout(carry0[0]),
        .block_propagate(block_propagate[0])
    );
    
    adder_4bit block0_1 (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(1'b1),
        .sum(sum1[3:0]),
        .cout(carry1[0]),
        .block_propagate()  // Not needed for first block
    );
    
    // Subsequent stages with carry-select and skip logic
    genvar i;
    generate
        for (i = 1; i < 4; i = i + 1) begin : adder_blocks
            // Compute both possible carry paths
            adder_4bit block0 (
                .a(a[4*i+3:4*i]),
                .b(b[4*i+3:4*i]),
                .cin(1'b0),
                .sum(sum0[4*i+3:4*i]),
                .cout(carry0[i]),
                .block_propagate(block_propagate[i])
            );
            
            adder_4bit block1 (
                .a(a[4*i+3:4*i]),
                .b(b[4*i+3:4*i]),
                .cin(1'b1),
                .sum(sum1[4*i+3:4*i]),
                .cout(carry1[i]),
                .block_propagate()
            );
            
            // Carry-skip logic
            assign carry_skip[i] = block_propagate[i-1] ? carry_skip[i-1] : carry0[i-1];
        end
    endgenerate
    
    // Final carry selection and output muxing
    wire [3:0] actual_carry;
    assign actual_carry[0] = Cin;
    
    genvar j;
    generate
        for (j = 1; j < 4; j = j + 1) begin : carry_select
            assign actual_carry[j] = actual_carry[j-1] ? carry1[j-1] : carry0[j-1];
            
            // Combine carry-select with carry-skip
            assign actual_carry[j] = block_propagate[j-1] ? carry_skip[j] : 
                                   (actual_carry[j-1] ? carry1[j-1] : carry0[j-1]);
        end
    endgenerate
    
    // Output selection
    assign y[3:0] = Cin ? sum1[3:0] : sum0[3:0];
    
    generate
        for (i = 1; i < 4; i = i + 1) begin : output_select
            assign y[4*i+3:4*i] = actual_carry[i] ? sum1[4*i+3:4*i] : sum0[4*i+3:4*i];
        end
    endgenerate
    
    assign Co = actual_carry[3] ? carry1[3] : carry0[3];
    // Final carry-skip optimization
    assign Co = (block_propagate[3] & block_propagate[2] & 
                block_propagate[1] & block_propagate[0]) ? Cin : 
                (actual_carry[3] ? carry1[3] : carry0[3]);
endmodule
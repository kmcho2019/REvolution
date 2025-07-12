module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Internal signals for 2-bit blocks
    wire [3:0] block_carry0;  // Carry chains assuming cin=0 for each block
    wire [3:0] block_carry1;  // Carry chains assuming cin=1 for each block
    wire [3:0] block_sum0;    // Sum bits assuming cin=0
    wire [3:0] block_sum1;    // Sum bits assuming cin=1
    wire [2:0] actual_carry;  // Actual carry between blocks

    // First block (bits 1:0)
    adder_2bit_block block0 (
        .a(a[1:0]),
        .b(b[1:0]),
        .cin(cin),
        .sum(sum[1:0]),
        .cout(actual_carry[0]),
        .sum0(block_sum0[0]),
        .sum1(block_sum1[0]),
        .carry0(block_carry0[0]),
        .carry1(block_carry1[0])
    );

    // Subsequent blocks with carry selection
    genvar i;
    generate
        for (i = 1; i < 4; i = i + 1) begin : adder_blocks
            // Compute both possible scenarios for each 2-bit block
            adder_2bit_block block (
                .a(a[2*i+1:2*i]),
                .b(b[2*i+1:2*i]),
                .cin(1'b0),
                .sum(),
                .cout(),
                .sum0(block_sum0[i]),
                .sum1(block_sum1[i]),
                .carry0(block_carry0[i]),
                .carry1(block_carry1[i])
            );

            // Carry selection mux
            assign sum[2*i+1:2*i] = actual_carry[i-1] ? block_sum1[i] : block_sum0[i];
            
            // Early termination if carry dies out
            assign actual_carry[i] = actual_carry[i-1] ? 
                                   (block_carry1[i] ? 1'b1 : 1'b0) : 
                                   (block_carry0[i] ? 1'b1 : 1'b0);
        end
    endgenerate

    assign cout = actual_carry[2];

endmodule

// 2-bit adder block with both carry scenarios
module adder_2bit_block (
    input [1:0] a,
    input [1:0] b,
    input cin,
    output [1:0] sum,
    output cout,
    output [1:0] sum0,
    output [1:0] sum1,
    output carry0,
    output carry1
);
    // Compute for cin=0 scenario
    wire [1:0] c0;
    assign c0[0] = a[0] & b[0];
    assign sum0[0] = a[0] ^ b[0];
    assign c0[1] = (a[1] & b[1]) | ((a[1] | b[1]) & c0[0]);
    assign sum0[1] = a[1] ^ b[1] ^ c0[0];
    assign carry0 = c0[1];

    // Compute for cin=1 scenario
    wire [1:0] c1;
    assign c1[0] = (a[0] & b[0]) | ((a[0] | b[0]) & cin);
    assign sum1[0] = a[0] ^ b[0] ^ cin;
    assign c1[1] = (a[1] & b[1]) | ((a[1] | b[1]) & c1[0]);
    assign sum1[1] = a[1] ^ b[1] ^ c1[0];
    assign carry1 = c1[1];

    // Actual output based on real cin
    assign sum[0] = a[0] ^ b[0] ^ cin;
    assign sum[1] = a[1] ^ b[1] ^ c1[0];
    assign cout = c1[1];
endmodule
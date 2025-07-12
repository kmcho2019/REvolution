module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Two's complement of B: ~B + 1
    wire [63:0] B_comp;
    assign B_comp = ~B;

    // Split inputs and complemented B into 8 blocks of 8 bits
    wire [7:0] A_block [7:0];
    wire [7:0] B_block [7:0];
    wire [7:0] sum0 [7:0]; // sum assuming carry_in = 0
    wire [7:0] sum1 [7:0]; // sum assuming carry_in = 1
    wire       cout0 [7:0]; // carry_out assuming carry_in = 0
    wire       cout1 [7:0]; // carry_out assuming carry_in = 1

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : assign_blocks
            assign A_block[i] = A[8*i +: 8];
            assign B_block[i] = B_comp[8*i +: 8];
        end
    endgenerate

    // First block adds A_block[0] + B_block[0] + cin (cin=1 for two's complement addition)
    // The rest add A_block[i] + B_block[i] + carry_in from previous block

    // We implement carry-select for each 8-bit block:
    // Precompute sums with carry_in=0 and carry_in=1

    // Block 0 (lowest 8 bits)
    wire [7:0] sum0_0, sum1_0;
    wire       cout0_0, cout1_0;
    cla_8bit cla0_0 (.A(A_block[0]), .B(B_block[0]), .cin(1'b0), .sum(sum0_0), .cout(cout0_0));
    cla_8bit cla1_0 (.A(A_block[0]), .B(B_block[0]), .cin(1'b1), .sum(sum1_0), .cout(cout1_0));

    // Select sum and carry_out based on initial carry_in = 1 (for ~B + 1)
    wire [7:0] sum_sel_0 = sum1_0; 
    wire       carry_sel_0 = cout1_0;

    // Store sums and couts
    assign sum0[0] = sum0_0;
    assign sum1[0] = sum1_0;
    assign cout0[0] = cout0_0;
    assign cout1[0] = cout1_0;

    // For blocks 1 to 7, implement similar carry-select blocks
    generate
        for (i = 1; i < 8; i = i + 1) begin : blocks_1_to_7
            cla_8bit cla0 (
                .A   (A_block[i]),
                .B   (B_block[i]),
                .cin (1'b0),
                .sum (sum0[i]),
                .cout(cout0[i])
            );
            cla_8bit cla1 (
                .A   (A_block[i]),
                .B   (B_block[i]),
                .cin (1'b1),
                .sum (sum1[i]),
                .cout(cout1[i])
            );
        end
    endgenerate

    // Now select sums and carry_outs sequentially using carry-select multiplexers
    wire [7:0] selected_sum [7:0];
    wire       carry_in;
    assign carry_in = 1'b1; // initial carry_in for first block

    // Block 0 sum selected already
    assign selected_sum[0] = sum_sel_0;

    // Carry-out from block 0 is carry_sel_0
    wire carry_out_0;
    assign carry_out_0 = carry_sel_0;

    // Sequentially propagate carry using multiplexers
    wire carry[7:0];
    assign carry[0] = carry_out_0;

    generate
        for (i = 1; i < 8; i = i + 1) begin : mux_sum_carry
            assign selected_sum[i] = carry[i-1] ? sum1[i] : sum0[i];
            assign carry[i] = carry[i-1] ? cout1[i] : cout0[i];
        end
    endgenerate

    // Concatenate all selected sums to form result
    generate
        for (i = 0; i < 8; i = i + 1) begin : concat_result
            assign result[8*i +: 8] = selected_sum[i];
        end
    endgenerate

    // Overflow detection:
    // overflow = (A_sign != B_sign) && (result_sign != A_sign)
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// 8-bit Carry Lookahead Adder (CLA)
module cla_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire [7:0] P; // propagate
    wire [7:0] G; // generate
    wire [8:0] C; // carry signals

    assign P = A ^ B;
    assign G = A & B;
    assign C[0] = cin;

    // Compute carries for each bit
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = G[3] | (P[3] & C[3]);
    assign C[5] = G[4] | (P[4] & C[4]);
    assign C[6] = G[5] | (P[5] & C[5]);
    assign C[7] = G[6] | (P[6] & C[6]);
    assign C[8] = G[7] | (P[7] & C[7]);

    assign sum = P ^ C[7:0];
    assign cout = C[8];

endmodule
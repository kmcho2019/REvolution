module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    // Clock gating control
    wire clk_gated = clk & (mul_en_in | |en_pipe);

    // Pipeline enable signals
    reg [2:0] en_pipe;

    // Stage 1: Partial product generation
    reg [7:0] a_reg, b_reg;
    wire [7:0][15:0] pp;  // 8 partial products (16-bit each)

    // Stage 2: Wallace Tree compression
    reg [15:0] sum_stg2, carry_stg2;

    // Stage 3: Final addition
    reg [15:0] final_sum;

    // Generate partial products with isolation
    generate
        for (genvar i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = (mul_en_in & b_reg[i]) ? ({8'b0, a_reg} << i) : 16'b0;
        end
    endgenerate

    // Wallace Tree compression (3:2 compressors)
    // First level compression
    wire [15:0] sum1, carry1;
    compressor_3to2_level1 comp1 (
        .pp0(pp[0]), .pp1(pp[1]), .pp2(pp[2]),
        .sum(sum1), .carry(carry1)
    );

    wire [15:0] sum2, carry2;
    compressor_3to2_level1 comp2 (
        .pp0(pp[3]), .pp1(pp[4]), .pp2(pp[5]),
        .sum(sum2), .carry(carry2)
    );

    // Second level compression
    wire [15:0] sum_int, carry_int;
    compressor_3to2_level2 comp3 (
        .sum1(sum1), .carry1(carry1),
        .sum2(sum2), .carry2(carry2),
        .pp(pp[6]),
        .sum(sum_int), .carry(carry_int)
    );

    // Final stage compression (with pp[7])
    wire [15:0] sum_final, carry_final;
    compressor_3to2_final comp4 (
        .sum(sum_int), .carry(carry_int),
        .pp(pp[7]),
        .sum(sum_final), .carry(carry_final)
    );

    // Pipeline registers with clock gating
    always @(posedge clk_gated or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            sum_stg2 <= 16'b0;
            carry_stg2 <= 16'b0;
            final_sum <= 16'b0;
            en_pipe <= 3'b0;
        end else begin
            // Stage 1: Input registration
            a_reg <= mul_a;
            b_reg <= mul_b;
            
            // Stage 2: Compression results
            sum_stg2 <= sum_final;
            carry_stg2 <= carry_final;
            
            // Stage 3: Final addition
            final_sum <= sum_stg2 + carry_stg2;
            
            // Pipeline enable shift register
            en_pipe <= {en_pipe[1:0], mul_en_in};
        end
    end

    // Output assignment with gating
    always @(*) begin
        mul_en_out = en_pipe[2];
        mul_out = en_pipe[2] ? final_sum : 16'b0;
    end

endmodule

// First level 3:2 compressor
module compressor_3to2_level1 (
    input [15:0] pp0, pp1, pp2,
    output [15:0] sum, carry
);
    assign sum = pp0 ^ pp1 ^ pp2;
    assign carry = ((pp0 & pp1) | (pp0 & pp2) | (pp1 & pp2)) << 1;
endmodule

// Second level 3:2 compressor
module compressor_3to2_level2 (
    input [15:0] sum1, carry1,
    input [15:0] sum2, carry2,
    input [15:0] pp,
    output [15:0] sum, carry
);
    wire [15:0] stage1_sum = sum1 + carry1;
    wire [15:0] stage2_sum = sum2 + carry2;
    
    assign sum = stage1_sum ^ stage2_sum ^ pp;
    assign carry = ((stage1_sum & stage2_sum) | 
                   (stage1_sum & pp) | 
                   (stage2_sum & pp)) << 1;
endmodule

// Final level 3:2 compressor
module compressor_3to2_final (
    input [15:0] sum, carry,
    input [15:0] pp,
    output [15:0] sum_out, carry_out
);
    wire [15:0] stage_sum = sum + carry;
    
    assign sum_out = stage_sum ^ pp;
    assign carry_out = ((stage_sum & pp)) << 1;
endmodule
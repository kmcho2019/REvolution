module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline enable signals (4 stages)
    reg [3:0] enable_pipe;

    // Stage 1: Input registers and partial products
    reg [7:0] a_reg, b_reg;
    wire [15:0] pp [7:0];  // Properly shifted partial products

    // Stage 2: First level compression (8->6 terms)
    reg [15:0] sum1_stage2, carry1_stage2;
    reg [15:0] sum2_stage2, carry2_stage2;
    reg [15:0] pp3_stage2, pp4_stage2;

    // Stage 3: Second level compression (6->4 terms)
    reg [15:0] sum1_stage3, carry1_stage3;
    reg [15:0] sum2_stage3, carry2_stage3;

    // Stage 4: Final compression and addition
    reg [15:0] sum_stage4, carry_stage4;
    reg [15:0] product_reg;

    // Generate properly shifted partial products
    generate
        genvar i;
        for (i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = b_reg[i] ? ({8'b0, a_reg} << i) : 16'b0;
        end
    endgenerate

    // Pipeline control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            enable_pipe <= 4'b0;
        end else begin
            enable_pipe <= {enable_pipe[2:0], mul_en_in};
        end
    end

    // Stage 1: Input sampling
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 8'b0;
            b_reg <= 8'b0;
        end else if (mul_en_in) begin
            a_reg <= mul_a;
            b_reg <= mul_b;
        end
    end

    // Stage 2: First level Wallace compression (8->6 terms)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum1_stage2 <= 16'b0;
            carry1_stage2 <= 16'b0;
            sum2_stage2 <= 16'b0;
            carry2_stage2 <= 16'b0;
            pp3_stage2 <= 16'b0;
            pp4_stage2 <= 16'b0;
        end else if (enable_pipe[0]) begin
            // First compressor: pp[0], pp[1], pp[2]
            sum1_stage2 <= pp[0] ^ pp[1] ^ pp[2];
            carry1_stage2 <= ((pp[0] & pp[1]) | (pp[0] & pp[2]) | (pp[1] & pp[2])) << 1;
            
            // Second compressor: pp[3], pp[4], pp[5]
            sum2_stage2 <= pp[3] ^ pp[4] ^ pp[5];
            carry2_stage2 <= ((pp[3] & pp[4]) | (pp[3] & pp[5]) | (pp[4] & pp[5])) << 1;
            
            // Pass through remaining terms
            pp3_stage2 <= pp[6];
            pp4_stage2 <= pp[7];
        end
    end

    // Stage 3: Second level compression (6->4 terms)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum1_stage3 <= 16'b0;
            carry1_stage3 <= 16'b0;
            sum2_stage3 <= 16'b0;
            carry2_stage3 <= 16'b0;
        end else if (enable_pipe[1]) begin
            // First compressor: sum1_stage2, carry1_stage2, sum2_stage2
            sum1_stage3 <= sum1_stage2 ^ carry1_stage2 ^ sum2_stage2;
            carry1_stage3 <= ((sum1_stage2 & carry1_stage2) | 
                            (sum1_stage2 & sum2_stage2) | 
                            (carry1_stage2 & sum2_stage2)) << 1;
            
            // Second compressor: carry2_stage2, pp3_stage2, pp4_stage2
            sum2_stage3 <= carry2_stage2 ^ pp3_stage2 ^ pp4_stage2;
            carry2_stage3 <= ((carry2_stage2 & pp3_stage2) | 
                            (carry2_stage2 & pp4_stage2) | 
                            (pp3_stage2 & pp4_stage2)) << 1;
        end
    end

    // Stage 4: Final compression and addition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage4 <= 16'b0;
            carry_stage4 <= 16'b0;
            product_reg <= 16'b0;
        end else if (enable_pipe[2]) begin
            // Final compression (4->2 terms)
            sum_stage4 <= sum1_stage3 ^ carry1_stage3 ^ sum2_stage3;
            carry_stage4 <= ((sum1_stage3 & carry1_stage3) | 
                           (sum1_stage3 & sum2_stage3) | 
                           (carry1_stage3 & sum2_stage3)) << 1;
            
            // Final addition
            product_reg <= sum_stage4 + carry_stage4 + carry2_stage3;
        end
    end

    // Output assignments
    assign mul_en_out = enable_pipe[3];
    assign mul_out = mul_en_out ? product_reg : 16'b0;

endmodule
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

    // Stage 0: Input registers
    reg [7:0] a_reg, b_reg;

    // Stage 1: Partial products
    wire [15:0] pp0, pp1, pp2, pp3, pp4, pp5, pp6, pp7;
    reg [15:0] pp0_reg, pp1_reg, pp2_reg, pp3_reg, pp4_reg, pp5_reg, pp6_reg, pp7_reg;

    // Stage 2: First compression (8->6 terms)
    wire [15:0] s1_stage2, c1_stage2, s2_stage2, c2_stage2;
    reg [15:0] s1_stage2_reg, c1_stage2_reg, s2_stage2_reg, c2_stage2_reg;
    reg [15:0] pp6_stage2_reg, pp7_stage2_reg;

    // Stage 3: Second compression (6->4 terms)
    wire [15:0] s1_stage3, c1_stage3, s2_stage3, c2_stage3;
    reg [15:0] s1_stage3_reg, c1_stage3_reg, s2_stage3_reg, c2_stage3_reg;

    // Stage 4: Final addition
    wire [15:0] final_sum, final_carry;
    reg [15:0] product_reg;

    // Generate partial products (combinational)
    assign pp0 = b_reg[0] ? {8'b0, a_reg} : 16'b0;
    assign pp1 = b_reg[1] ? {7'b0, a_reg, 1'b0} : 16'b0;
    assign pp2 = b_reg[2] ? {6'b0, a_reg, 2'b0} : 16'b0;
    assign pp3 = b_reg[3] ? {5'b0, a_reg, 3'b0} : 16'b0;
    assign pp4 = b_reg[4] ? {4'b0, a_reg, 4'b0} : 16'b0;
    assign pp5 = b_reg[5] ? {3'b0, a_reg, 5'b0} : 16'b0;
    assign pp6 = b_reg[6] ? {2'b0, a_reg, 6'b0} : 16'b0;
    assign pp7 = b_reg[7] ? {1'b0, a_reg, 7'b0} : 16'b0;

    // First level compression (8->6)
    assign s1_stage2 = pp0_reg ^ pp1_reg ^ pp2_reg;
    assign c1_stage2 = ((pp0_reg & pp1_reg) | (pp0_reg & pp2_reg) | (pp1_reg & pp2_reg)) << 1;
    assign s2_stage2 = pp3_reg ^ pp4_reg ^ pp5_reg;
    assign c2_stage2 = ((pp3_reg & pp4_reg) | (pp3_reg & pp5_reg) | (pp4_reg & pp5_reg)) << 1;

    // Second level compression (6->4)
    assign s1_stage3 = s1_stage2_reg ^ c1_stage2_reg ^ s2_stage2_reg;
    assign c1_stage3 = ((s1_stage2_reg & c1_stage2_reg) | (s1_stage2_reg & s2_stage2_reg) | (c1_stage2_reg & s2_stage2_reg)) << 1;
    assign s2_stage3 = c2_stage2_reg ^ pp6_stage2_reg ^ pp7_stage2_reg;
    assign c2_stage3 = ((c2_stage2_reg & pp6_stage2_reg) | (c2_stage2_reg & pp7_stage2_reg) | (pp6_stage2_reg & pp7_stage2_reg)) << 1;

    // Final addition
    assign final_sum = s1_stage3_reg ^ c1_stage3_reg ^ s2_stage3_reg;
    assign final_carry = ((s1_stage3_reg & c1_stage3_reg) | (s1_stage3_reg & s2_stage3_reg) | (c1_stage3_reg & s2_stage3_reg)) << 1;

    // Pipeline control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            enable_pipe <= 4'b0;
        end else begin
            enable_pipe <= {enable_pipe[2:0], mul_en_in};
        end
    end

    // Stage 0: Input sampling
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 8'b0;
            b_reg <= 8'b0;
        end else if (mul_en_in) begin
            a_reg <= mul_a;
            b_reg <= mul_b;
        end
    end

    // Stage 1: Partial product registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pp0_reg <= 16'b0;
            pp1_reg <= 16'b0;
            pp2_reg <= 16'b0;
            pp3_reg <= 16'b0;
            pp4_reg <= 16'b0;
            pp5_reg <= 16'b0;
            pp6_reg <= 16'b0;
            pp7_reg <= 16'b0;
        end else if (enable_pipe[0]) begin
            pp0_reg <= pp0;
            pp1_reg <= pp1;
            pp2_reg <= pp2;
            pp3_reg <= pp3;
            pp4_reg <= pp4;
            pp5_reg <= pp5;
            pp6_reg <= pp6;
            pp7_reg <= pp7;
        end
    end

    // Stage 2: First compression registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            s1_stage2_reg <= 16'b0;
            c1_stage2_reg <= 16'b0;
            s2_stage2_reg <= 16'b0;
            c2_stage2_reg <= 16'b0;
            pp6_stage2_reg <= 16'b0;
            pp7_stage2_reg <= 16'b0;
        end else if (enable_pipe[1]) begin
            s1_stage2_reg <= s1_stage2;
            c1_stage2_reg <= c1_stage2;
            s2_stage2_reg <= s2_stage2;
            c2_stage2_reg <= c2_stage2;
            pp6_stage2_reg <= pp6_reg;
            pp7_stage2_reg <= pp7_reg;
        end
    end

    // Stage 3: Second compression registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            s1_stage3_reg <= 16'b0;
            c1_stage3_reg <= 16'b0;
            s2_stage3_reg <= 16'b0;
            c2_stage3_reg <= 16'b0;
        end else if (enable_pipe[2]) begin
            s1_stage3_reg <= s1_stage3;
            c1_stage3_reg <= c1_stage3;
            s2_stage3_reg <= s2_stage3;
            c2_stage3_reg <= c2_stage3;
        end
    end

    // Stage 4: Final addition and product register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product_reg <= 16'b0;
        end else if (enable_pipe[3]) begin
            product_reg <= final_sum + final_carry + c2_stage3_reg;
        end
    end

    // Output assignments
    assign mul_en_out = enable_pipe[3];
    assign mul_out = product_reg;

endmodule
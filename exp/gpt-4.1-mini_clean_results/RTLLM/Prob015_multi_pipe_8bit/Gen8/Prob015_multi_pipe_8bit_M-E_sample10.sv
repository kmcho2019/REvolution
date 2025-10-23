module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

    // Enable pipeline (4 stages) to track valid data through the pipeline
    reg [3:0] mul_en_pipe;

    // Stage 1 registers: input sampling
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Stage 2 registers: partial products
    reg [15:0] pp [7:0];  // partial products 0 to 7

    // Stage 3 registers: pairwise sums of partial products
    reg [15:0] sum_stage3 [3:0]; // sums of pairs

    // Stage 4 registers: final sums
    reg [15:0] sum_stage4_0, sum_stage4_1;

    // Stage 5 register: final product
    reg [15:0] mul_out_reg;

    integer i;

    // Pipeline enable shift register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_pipe <= 4'b0;
        else
            mul_en_pipe <= {mul_en_pipe[2:0], mul_en_in};
    end

    // Stage 1: Input registers sampling when mul_en_in active
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // Stage 2: Generate and register partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 8; i = i + 1)
                pp[i] <= 16'd0;
        end else begin
            for (i = 0; i < 8; i = i + 1)
                pp[i] <= mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
        end
    end

    // Stage 3: Pairwise add partial products and register sums
    // sums: pp[0]+pp[1], pp[2]+pp[3], pp[4]+pp[5], pp[6]+pp[7]
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 4; i = i + 1)
                sum_stage3[i] <= 16'd0;
        end else begin
            sum_stage3[0] <= pp[0] + pp[1];
            sum_stage3[1] <= pp[2] + pp[3];
            sum_stage3[2] <= pp[4] + pp[5];
            sum_stage3[3] <= pp[6] + pp[7];
        end
    end

    // Stage 4: Add pairs of sums and register
    // sum_stage4_0 = sum_stage3[0] + sum_stage3[1]
    // sum_stage4_1 = sum_stage3[2] + sum_stage3[3]
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage4_0 <= 16'd0;
            sum_stage4_1 <= 16'd0;
        end else begin
            sum_stage4_0 <= sum_stage3[0] + sum_stage3[1];
            sum_stage4_1 <= sum_stage3[2] + sum_stage3[3];
        end
    end

    // Stage 5: Final addition and register output product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out_reg <= 16'd0;
        else
            mul_out_reg <= sum_stage4_0 + sum_stage4_1;
    end

    // Output enable signal from last stage of pipeline
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_out <= 1'b0;
        else
            mul_en_out <= mul_en_pipe[3];
    end

    // Output product gated by output enable
    always @(*) begin
        mul_out = mul_en_out ? mul_out_reg : 16'd0;
    end

endmodule
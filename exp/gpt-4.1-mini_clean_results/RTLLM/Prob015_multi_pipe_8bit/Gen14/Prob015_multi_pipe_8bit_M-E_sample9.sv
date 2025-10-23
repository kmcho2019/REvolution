module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output reg      mul_en_out,
    output reg [15:0] mul_out
);

    // Pipeline enable shift register for 5 stages
    reg [4:0] mul_en_pipe;

    // Stage 0: Input registers for multiplicand and multiplier
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Stage 1: Partial products (8 x 16-bit)
    reg [15:0] pp [7:0];

    // Stage 2: Pairwise sum registers (4 sums)
    reg [15:0] sum_01, sum_23, sum_45, sum_67;

    // Stage 3: Pairwise sum registers (2 sums)
    reg [15:0] sum_0123, sum_4567;

    // Stage 4: Final sum register (product)
    reg [15:0] mul_out_reg;

    integer i;

    // 1) Pipeline mul_en_in through 5 stages to track validity
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_pipe <= 5'b0;
        else
            mul_en_pipe <= {mul_en_pipe[3:0], mul_en_in};
    end

    // 2) Stage 0: Sample inputs when mul_en_in asserted
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // 3) Stage 1: Generate partial products when stage 1 enable asserted
    // Each partial product is mul_a_reg shifted by bit position i if mul_b_reg[i] == 1, else 0
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i=0; i<8; i=i+1)
                pp[i] <= 16'd0;
        end else if (mul_en_pipe[0]) begin
            for (i=0; i<8; i=i+1) begin
                pp[i] <= mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
            end
        end else begin
            for (i=0; i<8; i=i+1)
                pp[i] <= 16'd0;
        end
    end

    // 4) Stage 2: Add pairs of partial products: (pp0+pp1), (pp2+pp3), (pp4+pp5), (pp6+pp7)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_01 <= 16'd0;
            sum_23 <= 16'd0;
            sum_45 <= 16'd0;
            sum_67 <= 16'd0;
        end else if (mul_en_pipe[1]) begin
            sum_01 <= pp[0] + pp[1];
            sum_23 <= pp[2] + pp[3];
            sum_45 <= pp[4] + pp[5];
            sum_67 <= pp[6] + pp[7];
        end else begin
            sum_01 <= 16'd0;
            sum_23 <= 16'd0;
            sum_45 <= 16'd0;
            sum_67 <= 16'd0;
        end
    end

    // 5) Stage 3: Add pairs of sums: (sum_01 + sum_23) and (sum_45 + sum_67)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_0123 <= 16'd0;
            sum_4567 <= 16'd0;
        end else if (mul_en_pipe[2]) begin
            sum_0123 <= sum_01 + sum_23;
            sum_4567 <= sum_45 + sum_67;
        end else begin
            sum_0123 <= 16'd0;
            sum_4567 <= 16'd0;
        end
    end

    // 6) Stage 4: Final addition to produce product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out_reg <= 16'd0;
        else if (mul_en_pipe[3])
            mul_out_reg <= sum_0123 + sum_4567;
        else
            mul_out_reg <= 16'd0;
    end

    // 7) Output enable assigned at final pipeline stage (stage 4 to stage 5)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_out <= 1'b0;
        else
            mul_en_out <= mul_en_pipe[4];
    end

    // 8) Output product assignment
    always @(*) begin
        if (mul_en_out)
            mul_out = mul_out_reg;
        else
            mul_out = 16'd0;
    end

endmodule
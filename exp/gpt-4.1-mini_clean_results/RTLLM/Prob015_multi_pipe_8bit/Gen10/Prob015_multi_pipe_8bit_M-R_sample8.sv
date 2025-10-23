module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline enable signals (4 stages)
    reg [3:0] mul_en_pipe;

    // Stage 1: Input registers
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Stage 2: Registered partial products (8 partial products)
    reg [15:0] pp_reg [7:0];

    // Stage 3: Pairwise sums (sum pairs of partial products)
    reg [15:0] sum_stage3_0, sum_stage3_1, sum_stage3_2, sum_stage3_3;

    // Stage 4: Final sum registers
    reg [15:0] sum_stage4_0, sum_stage4_1;

    // Stage 5: Final product register
    reg [15:0] mul_out_reg;

    integer i;

    // Stage 1: Sample inputs and propagate enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_pipe <= 4'b0;
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
        end else begin
            mul_en_pipe <= {mul_en_pipe[2:0], mul_en_in};
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // Stage 2: Generate partial products registered
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i=0; i<8; i=i+1) begin
                pp_reg[i] <= 16'd0;
            end
        end else if (mul_en_pipe[0]) begin
            for (i=0; i<8; i=i+1) begin
                // Each partial product is mul_a shifted by i if mul_b_reg[i] is 1
                pp_reg[i] <= mul_b_reg[i] ? ( {8'd0, mul_a_reg} << i ) : 16'd0;
            end
        end else begin
            for (i=0; i<8; i=i+1) begin
                pp_reg[i] <= 16'd0;
            end
        end
    end

    // Stage 3: Pairwise sum partial products in 4 adders
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage3_0 <= 16'd0;
            sum_stage3_1 <= 16'd0;
            sum_stage3_2 <= 16'd0;
            sum_stage3_3 <= 16'd0;
        end else if (mul_en_pipe[1]) begin
            sum_stage3_0 <= pp_reg[0] + pp_reg[1];
            sum_stage3_1 <= pp_reg[2] + pp_reg[3];
            sum_stage3_2 <= pp_reg[4] + pp_reg[5];
            sum_stage3_3 <= pp_reg[6] + pp_reg[7];
        end else begin
            sum_stage3_0 <= 16'd0;
            sum_stage3_1 <= 16'd0;
            sum_stage3_2 <= 16'd0;
            sum_stage3_3 <= 16'd0;
        end
    end

    // Stage 4: Sum pairs from previous stage into two adders
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage4_0 <= 16'd0;
            sum_stage4_1 <= 16'd0;
        end else if (mul_en_pipe[2]) begin
            sum_stage4_0 <= sum_stage3_0 + sum_stage3_1;
            sum_stage4_1 <= sum_stage3_2 + sum_stage3_3;
        end else begin
            sum_stage4_0 <= 16'd0;
            sum_stage4_1 <= 16'd0;
        end
    end

    // Stage 5: Final summation and register output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'd0;
        end else if (mul_en_pipe[3]) begin
            mul_out_reg <= sum_stage4_0 + sum_stage4_1;
        end else begin
            mul_out_reg <= 16'd0;
        end
    end

    // Output enable indicates valid product at mul_out_reg (stage 5)
    assign mul_en_out = mul_en_pipe[3];

    // Output mux: zero when output not valid
    assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule
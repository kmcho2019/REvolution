module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline enable shift register (4 stages)
    reg [3:0] en_pipe;

    // Stage 0: Input registers
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Stage 1: Partial products registered
    reg [15:0] pp_reg[7:0];

    // Stage 2: Partial sums registers
    reg [15:0] sum_low_reg;  // sum of pp_reg[0..3]
    reg [15:0] sum_high_reg; // sum of pp_reg[4..7]

    // Stage 3: Final product register
    reg [15:0] mul_out_reg;

    integer i;

    // 1) Enable shift register tracking pipeline stages
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            en_pipe <= 4'd0;
        else
            en_pipe <= {en_pipe[2:0], mul_en_in};
    end

    // 2) Sample inputs when mul_en_in asserted
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // 3) Generate and register partial products on stage 1 when en_pipe[0] asserted
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 8; i = i + 1)
                pp_reg[i] <= 16'd0;
        end else if (en_pipe[0]) begin
            for (i = 0; i < 8; i = i + 1) begin
                pp_reg[i] <= mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
            end
        end else begin
            for (i = 0; i < 8; i = i + 1)
                pp_reg[i] <= 16'd0;
        end
    end

    // 4) Sum partial products in two groups and register on stage 2 when en_pipe[1] asserted
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_low_reg <= 16'd0;
            sum_high_reg <= 16'd0;
        end else if (en_pipe[1]) begin
            sum_low_reg  <= pp_reg[0] + pp_reg[1] + pp_reg[2] + pp_reg[3];
            sum_high_reg <= pp_reg[4] + pp_reg[5] + pp_reg[6] + pp_reg[7];
        end else begin
            sum_low_reg <= 16'd0;
            sum_high_reg <= 16'd0;
        end
    end

    // 5) Final sum and register product on stage 3 when en_pipe[2] asserted
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out_reg <= 16'd0;
        else if (en_pipe[2])
            mul_out_reg <= sum_low_reg + sum_high_reg;
        else
            mul_out_reg <= 16'd0;
    end

    // Output enable from last stage of enable pipeline (stage 3)
    assign mul_en_out = en_pipe[3];

    // Output product only valid when mul_en_out asserted
    assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule
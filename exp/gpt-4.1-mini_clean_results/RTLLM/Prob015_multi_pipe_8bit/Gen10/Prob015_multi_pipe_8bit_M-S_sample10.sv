module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Enable pipeline: 3 stages to track valid data
    reg [2:0] mul_en_pipe;

    // Input registers: sample inputs when mul_en_in is active
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products sum register (stage 2)
    reg [15:0] partial_sum_reg;

    // Final product register (stage 3)
    reg [15:0] mul_out_reg;

    integer i;
    reg [15:0] partial_sum_comb;

    // Enable pipeline update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_pipe <= 3'b0;
        else
            mul_en_pipe <= {mul_en_pipe[1:0], mul_en_in};
    end

    // Input registers update on mul_en_in active
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // Partial products sum combinational calculation
    always @(*) begin
        partial_sum_comb = 16'b0;
        for (i = 0; i < 8; i = i + 1) begin
            if (mul_b_reg[i])
                partial_sum_comb = partial_sum_comb + (mul_a_reg << i);
        end
    end

    // Register partial sum at stage 2 when mul_en_pipe[1] is active
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            partial_sum_reg <= 16'b0;
        else if (mul_en_pipe[1])
            partial_sum_reg <= partial_sum_comb;
    end

    // Register final product at stage 3 when mul_en_pipe[2] is active
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out_reg <= 16'b0;
        else if (mul_en_pipe[2])
            mul_out_reg <= partial_sum_reg;
    end

    // Output enable from MSB of enable pipeline
    assign mul_en_out = mul_en_pipe[2];

    // Output product valid only when enable active, else zero
    assign mul_out = mul_en_out ? mul_out_reg : 16'b0;

endmodule
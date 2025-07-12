module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline enable signal, 4 stages to match pipeline depth
    reg [3:0] mul_en_pipe;

    // Input registers for operands
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Stage 1: Partial products registered individually (each 16-bit)
    reg [15:0] pp_reg [7:0];

    // Stage 2: Sum pairs of partial products to reduce addition complexity
    reg [15:0] sum_pairs_reg [3:0];

    // Stage 3: Sum results of pairs to get partial sums
    reg [15:0] sum_half1_reg;
    reg [15:0] sum_half2_reg;

    // Stage 4: Final product register
    reg [15:0] mul_out_reg;

    integer i;

    // Stage 0: Sample inputs and shift enable pipeline
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

    // Stage 1: Generate and register partial products on clock
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 8; i = i + 1) begin
                pp_reg[i] <= 16'd0;
            end
        end else if (mul_en_pipe[0]) begin
            for (i = 0; i < 8; i = i + 1) begin
                pp_reg[i] <= mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
            end
        end else begin
            for (i = 0; i < 8; i = i + 1) begin
                pp_reg[i] <= 16'd0;
            end
        end
    end

    // Stage 2: Sum partial products in pairs (registered)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 4; i = i + 1) begin
                sum_pairs_reg[i] <= 16'd0;
            end
        end else if (mul_en_pipe[1]) begin
            sum_pairs_reg[0] <= pp_reg[0] + pp_reg[1];
            sum_pairs_reg[1] <= pp_reg[2] + pp_reg[3];
            sum_pairs_reg[2] <= pp_reg[4] + pp_reg[5];
            sum_pairs_reg[3] <= pp_reg[6] + pp_reg[7];
        end else begin
            for (i = 0; i < 4; i = i + 1) begin
                sum_pairs_reg[i] <= 16'd0;
            end
        end
    end

    // Stage 3: Sum halves registered
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_half1_reg <= 16'd0;
            sum_half2_reg <= 16'd0;
        end else if (mul_en_pipe[2]) begin
            sum_half1_reg <= sum_pairs_reg[0] + sum_pairs_reg[1];
            sum_half2_reg <= sum_pairs_reg[2] + sum_pairs_reg[3];
        end else begin
            sum_half1_reg <= 16'd0;
            sum_half2_reg <= 16'd0;
        end
    end

    // Stage 4: Final sum and product output registered
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'd0;
        end else if (mul_en_pipe[3]) begin
            mul_out_reg <= sum_half1_reg + sum_half2_reg;
        end else begin
            mul_out_reg <= 16'd0;
        end
    end

    // Output enable signal indicates valid product on mul_out_reg
    assign mul_en_out = mul_en_pipe[3];

    // Output product is valid only when mul_en_out is high
    assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule
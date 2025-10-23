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
    reg [3:0] mul_en_pipe;

    // Input operand registers
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Stage 1: Partial product registers (8 partial products)
    reg [15:0] pp_reg [7:0];

    // Stage 2: Partial sum level 1 (sum pairs of partial products)
    reg [15:0] sum_level1 [3:0];

    // Stage 3: Partial sum level 2 (sum level1 outputs in pairs)
    reg [15:0] sum_level2 [1:0];

    // Stage 4: Final sum register (output)
    reg [15:0] mul_out_reg;

    integer i;

    // Stage 0: Input registers and enable pipeline
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

    // Stage 1: Generate and register partial products (one-hot multiplication by each bit of mul_b_reg)
    // Each partial product = (mul_b_reg bit ? (mul_a_reg << bit_index) : 0)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 8; i = i + 1)
                pp_reg[i] <= 16'd0;
        end else if (mul_en_pipe[0]) begin
            // Generate partial products only when stage 0 enable is active
            for (i = 0; i < 8; i = i + 1) begin
                pp_reg[i] <= mul_b_reg[i] ? ( {8'd0, mul_a_reg} << i ) : 16'd0;
            end
        end else begin
            // Hold previous partial products if no new valid input
            for (i = 0; i < 8; i = i + 1)
                pp_reg[i] <= pp_reg[i];
        end
    end

    // Stage 2: Sum pairs of partial products (4 sums)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 4; i = i + 1)
                sum_level1[i] <= 16'd0;
        end else if (mul_en_pipe[1]) begin
            sum_level1[0] <= pp_reg[0] + pp_reg[1];
            sum_level1[1] <= pp_reg[2] + pp_reg[3];
            sum_level1[2] <= pp_reg[4] + pp_reg[5];
            sum_level1[3] <= pp_reg[6] + pp_reg[7];
        end else begin
            for (i = 0; i < 4; i = i + 1)
                sum_level1[i] <= sum_level1[i];
        end
    end

    // Stage 3: Sum pairs of sums from stage 2 (2 sums)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_level2[0] <= 16'd0;
            sum_level2[1] <= 16'd0;
        end else if (mul_en_pipe[2]) begin
            sum_level2[0] <= sum_level1[0] + sum_level1[1];
            sum_level2[1] <= sum_level1[2] + sum_level1[3];
        end else begin
            sum_level2[0] <= sum_level2[0];
            sum_level2[1] <= sum_level2[1];
        end
    end

    // Stage 4: Final sum and output register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'd0;
        end else if (mul_en_pipe[3]) begin
            mul_out_reg <= sum_level2[0] + sum_level2[1];
        end else begin
            mul_out_reg <= 16'd0;
        end
    end

    // Output enable derived from last stage of enable pipeline
    assign mul_en_out = mul_en_pipe[3];

    // Output product valid when mul_en_out is high, else 0
    assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule
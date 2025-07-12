module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline stages count: 5
    // Enable pipeline shift register to track valid data through pipeline stages
    reg [4:0] mul_en_pipe;

    // Stage 1: Input registers - sample inputs when enabled
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Stage 2: Generate partial products and register them
    reg [15:0] pp_reg [7:0];  // partial product registers (8 elements)

    integer i;

    // Stage 3: Add partial products pairwise (4 adders), register results
    reg [15:0] sum_stage3 [3:0];

    // Stage 4: Add sums from stage 3 pairwise (2 adders), register results
    reg [15:0] sum_stage4 [1:0];

    // Stage 5: Final addition (1 adder), register the final product
    reg [15:0] mul_out_reg;

    // Enable pipeline shift register updates
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_pipe <= 5'b0;
        else
            mul_en_pipe <= {mul_en_pipe[3:0], mul_en_in};
    end

    // Stage 1: Input registers sample inputs on mul_en_in
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // Stage 2: Generate partial products combinationally and register them
    wire [15:0] partial_products [7:0];
    generate
        genvar idx;
        for (idx = 0; idx < 8; idx = idx + 1) begin : gen_pp
            assign partial_products[idx] = mul_b_reg[idx] ? (mul_a_reg << idx) : 16'd0;
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 8; i = i + 1)
                pp_reg[i] <= 16'd0;
        end else if (mul_en_pipe[0]) begin
            for (i = 0; i < 8; i = i + 1)
                pp_reg[i] <= partial_products[i];
        end else begin
            for (i = 0; i < 8; i = i + 1)
                pp_reg[i] <= 16'd0;
        end
    end

    // Stage 3: Add pairs of partial products (pp_reg) -> sum_stage3
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 4; i = i + 1)
                sum_stage3[i] <= 16'd0;
        end else if (mul_en_pipe[1]) begin
            sum_stage3[0] <= pp_reg[0] + pp_reg[1];
            sum_stage3[1] <= pp_reg[2] + pp_reg[3];
            sum_stage3[2] <= pp_reg[4] + pp_reg[5];
            sum_stage3[3] <= pp_reg[6] + pp_reg[7];
        end else begin
            for (i = 0; i < 4; i = i + 1)
                sum_stage3[i] <= 16'd0;
        end
    end

    // Stage 4: Add pairs from sum_stage3 -> sum_stage4
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage4[0] <= 16'd0;
            sum_stage4[1] <= 16'd0;
        end else if (mul_en_pipe[2]) begin
            sum_stage4[0] <= sum_stage3[0] + sum_stage3[1];
            sum_stage4[1] <= sum_stage3[2] + sum_stage3[3];
        end else begin
            sum_stage4[0] <= 16'd0;
            sum_stage4[1] <= 16'd0;
        end
    end

    // Stage 5: Final addition and output register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out_reg <= 16'd0;
        else if (mul_en_pipe[3])
            mul_out_reg <= sum_stage4[0] + sum_stage4[1];
        else
            mul_out_reg <= 16'd0;
    end

    // Output enable is the MSB of the enable pipeline
    assign mul_en_out = mul_en_pipe[4];

    // Output muxed with enable signal
    assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule
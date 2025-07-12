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

    // Partial products (wires)
    wire [15:0] partial_products[7:0];

    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : gen_partial_products
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'b0;
        end
    endgenerate

    // Stage 1: Pairwise sums of partial products (4 registers)
    reg [15:0] sum_stage1[3:0];
    wire [15:0] sum_stage1_wire[3:0];

    assign sum_stage1_wire[0] = partial_products[0] + partial_products[1];
    assign sum_stage1_wire[1] = partial_products[2] + partial_products[3];
    assign sum_stage1_wire[2] = partial_products[4] + partial_products[5];
    assign sum_stage1_wire[3] = partial_products[6] + partial_products[7];

    // Stage 2: Sum pairs of sums from stage 1 (2 registers)
    reg [15:0] sum_stage2[1:0];
    wire [15:0] sum_stage2_wire[1:0];

    assign sum_stage2_wire[0] = sum_stage1[0] + sum_stage1[1];
    assign sum_stage2_wire[1] = sum_stage1[2] + sum_stage1[3];

    // Stage 3: Final sum register
    reg [15:0] mul_out_reg;
    wire [15:0] final_sum_wire;

    assign final_sum_wire = sum_stage2[0] + sum_stage2[1];

    // 1) Enable pipeline shift register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_pipe <= 4'b0;
        else
            mul_en_pipe <= {mul_en_pipe[2:0], mul_en_in};
    end

    // 2) Input registers sampled on mul_en_in
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // 3) Stage 1 registers: pairwise sums
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage1[0] <= 16'b0;
            sum_stage1[1] <= 16'b0;
            sum_stage1[2] <= 16'b0;
            sum_stage1[3] <= 16'b0;
        end else if (mul_en_pipe[1]) begin
            sum_stage1[0] <= sum_stage1_wire[0];
            sum_stage1[1] <= sum_stage1_wire[1];
            sum_stage1[2] <= sum_stage1_wire[2];
            sum_stage1[3] <= sum_stage1_wire[3];
        end else begin
            sum_stage1[0] <= 16'b0;
            sum_stage1[1] <= 16'b0;
            sum_stage1[2] <= 16'b0;
            sum_stage1[3] <= 16'b0;
        end
    end

    // 4) Stage 2 registers: sum pairs of stage 1 sums
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage2[0] <= 16'b0;
            sum_stage2[1] <= 16'b0;
        end else if (mul_en_pipe[2]) begin
            sum_stage2[0] <= sum_stage2_wire[0];
            sum_stage2[1] <= sum_stage2_wire[1];
        end else begin
            sum_stage2[0] <= 16'b0;
            sum_stage2[1] <= 16'b0;
        end
    end

    // 5) Stage 3 register: final sum
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out_reg <= 16'b0;
        else if (mul_en_pipe[3])
            mul_out_reg <= final_sum_wire;
        else
            mul_out_reg <= 16'b0;
    end

    // Output enable from MSB of enable pipeline
    assign mul_en_out = mul_en_pipe[3];

    // Output product gated by output enable
    assign mul_out = mul_en_out ? mul_out_reg : 16'b0;

endmodule
module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

    // Pipeline enable signal: track valid data through 4 pipeline stages
    reg [3:0] mul_en_pipe;

    // Stage 0: Input registers (capture inputs when mul_en_in is high)
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products wires (gated by enable and multiplier bit)
    wire [15:0] partial_products [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = (mul_en_pipe[0] && mul_b_reg[i]) ? (mul_a_reg << i) : 16'd0;
        end
    endgenerate

    // Stage 1 registers: sum pairs of partial products (4 sums)
    reg [15:0] sum_stage1 [3:0];

    // Stage 2 registers: sum pairs of stage1 sums (2 sums)
    reg [15:0] sum_stage2 [1:0];

    // Stage 3 register: final sum output
    reg [15:0] mul_out_reg;

    integer idx;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_pipe <= 4'b0;
            mul_a_reg   <= 8'd0;
            mul_b_reg   <= 8'd0;
            mul_out_reg <= 16'd0;
            mul_en_out  <= 1'b0;
            mul_out     <= 16'd0;
            for (idx = 0; idx < 4; idx = idx + 1) sum_stage1[idx] <= 16'd0;
            for (idx = 0; idx < 2; idx = idx + 1) sum_stage2[idx] <= 16'd0;
        end else begin
            // Shift enable pipeline and insert new enable bit
            mul_en_pipe <= {mul_en_pipe[2:0], mul_en_in};

            // Stage 0: capture inputs on mul_en_in
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end

            // Stage 1: sum partial products in pairs, register results
            if (mul_en_pipe[0]) begin
                sum_stage1[0] <= partial_products[0] + partial_products[1];
                sum_stage1[1] <= partial_products[2] + partial_products[3];
                sum_stage1[2] <= partial_products[4] + partial_products[5];
                sum_stage1[3] <= partial_products[6] + partial_products[7];
            end else begin
                for (idx = 0; idx < 4; idx = idx + 1)
                    sum_stage1[idx] <= 16'd0;
            end

            // Stage 2: sum pairs of stage1 results, register results
            if (mul_en_pipe[1]) begin
                sum_stage2[0] <= sum_stage1[0] + sum_stage1[1];
                sum_stage2[1] <= sum_stage1[2] + sum_stage1[3];
            end else begin
                sum_stage2[0] <= 16'd0;
                sum_stage2[1] <= 16'd0;
            end

            // Stage 3: final sum output register
            if (mul_en_pipe[2])
                mul_out_reg <= sum_stage2[0] + sum_stage2[1];
            else
                mul_out_reg <= 16'd0;

            // Output enable signal at pipeline stage 3
            mul_en_out <= mul_en_pipe[3];

            // Output assignment with enable gating
            mul_out <= mul_en_out ? mul_out_reg : 16'd0;
        end
    end

endmodule
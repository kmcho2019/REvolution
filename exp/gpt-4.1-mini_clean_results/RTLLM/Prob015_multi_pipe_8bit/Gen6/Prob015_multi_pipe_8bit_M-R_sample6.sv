module multi_pipe_8bit (
    input               clk,
    input               rst_n,
    input               mul_en_in,
    input       [7:0]   mul_a,
    input       [7:0]   mul_b,
    output reg          mul_en_out,
    output reg  [15:0]  mul_out
);

    // Pipeline enable registers (3 stages for clarity)
    reg [2:0] mul_en_pipe;

    // Input registers
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Stage 1: Partial products generation (wires)
    wire [15:0] partial_products [7:0];
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : gen_pp
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
        end
    endgenerate

    // Stage 1 registers: store partial products (pipeline stage 1 registers)
    reg [15:0] pp_reg [7:0];
    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_pipe <= 3'b000;
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
            for (j = 0; j < 8; j = j + 1)
                pp_reg[j] <= 16'd0;
        end else begin
            mul_en_pipe <= {mul_en_pipe[1:0], mul_en_in};
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
            if (mul_en_pipe[0]) begin
                for (j = 0; j < 8; j = j + 1)
                    pp_reg[j] <= partial_products[j];
            end else begin
                for (j = 0; j < 8; j = j + 1)
                    pp_reg[j] <= 16'd0;
            end
        end
    end

    // Stage 2: Partial sum adds (pairwise) and register sums
    // sum stage 2 registers hold sums of pairs of pp_reg
    reg [15:0] sum_stage2 [3:0];
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j=0; j<4; j=j+1)
                sum_stage2[j] <= 16'd0;
        end else if (mul_en_pipe[1]) begin
            sum_stage2[0] <= pp_reg[0] + pp_reg[1];
            sum_stage2[1] <= pp_reg[2] + pp_reg[3];
            sum_stage2[2] <= pp_reg[4] + pp_reg[5];
            sum_stage2[3] <= pp_reg[6] + pp_reg[7];
        end else begin
            for (j=0; j<4; j=j+1)
                sum_stage2[j] <= 16'd0;
        end
    end

    // Stage 3: Partial sum adds of sum_stage2 pairs
    reg [15:0] sum_stage3 [1:0];
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage3[0] <= 16'd0;
            sum_stage3[1] <= 16'd0;
        end else if (mul_en_pipe[2]) begin
            sum_stage3[0] <= sum_stage2[0] + sum_stage2[1];
            sum_stage3[1] <= sum_stage2[2] + sum_stage2[3];
        end else begin
            sum_stage3[0] <= 16'd0;
            sum_stage3[1] <= 16'd0;
        end
    end

    // Stage 4: Final product register (sum of last two sums)
    reg [15:0] mul_out_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out_reg <= 16'd0;
        else if (mul_en_pipe[2])
            mul_out_reg <= sum_stage3[0] + sum_stage3[1];
        else
            mul_out_reg <= 16'd0;
    end

    // Output enable signal (registered at stage 3)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_out <= 1'b0;
        else
            mul_en_out <= mul_en_pipe[2];
    end

    // Output assignment gated by output enable
    always @(*) begin
        mul_out = mul_en_out ? mul_out_reg : 16'd0;
    end

endmodule
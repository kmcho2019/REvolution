module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline enable register (4 stages)
    reg [3:0] mul_en_pipe;

    // Stage 1 registers: input operands
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Stage 1 partial products (wires)
    wire [15:0] pp [7:0];
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : gen_pp
            assign pp[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'b0;
        end
    endgenerate

    // Stage 2 registers: sum pairs of partial products
    // sum2_0 = pp[0] + pp[1]
    // sum2_1 = pp[2] + pp[3]
    // sum2_2 = pp[4] + pp[5]
    // sum2_3 = pp[6] + pp[7]
    reg [15:0] sum2_0_reg, sum2_1_reg, sum2_2_reg, sum2_3_reg;

    // Stage 3 registers: sum pairs of stage2 sums
    // sum3_0 = sum2_0 + sum2_1
    // sum3_1 = sum2_2 + sum2_3
    reg [15:0] sum3_0_reg, sum3_1_reg;

    // Stage 4 register: final sum
    reg [15:0] mul_out_reg;

    // Pipeline stage 1: register inputs on mul_en_in
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // Pipeline enable shift register (4 stages)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_pipe <= 4'b0;
        else
            mul_en_pipe <= {mul_en_pipe[2:0], mul_en_in};
    end

    // Stage 2: sum pairs of partial products registered when mul_en_pipe[0] is high
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum2_0_reg <= 16'd0;
            sum2_1_reg <= 16'd0;
            sum2_2_reg <= 16'd0;
            sum2_3_reg <= 16'd0;
        end else if (mul_en_pipe[0]) begin
            sum2_0_reg <= pp[0] + pp[1];
            sum2_1_reg <= pp[2] + pp[3];
            sum2_2_reg <= pp[4] + pp[5];
            sum2_3_reg <= pp[6] + pp[7];
        end else begin
            sum2_0_reg <= 16'd0;
            sum2_1_reg <= 16'd0;
            sum2_2_reg <= 16'd0;
            sum2_3_reg <= 16'd0;
        end
    end

    // Stage 3: sum pairs of stage2 sums registered when mul_en_pipe[1] is high
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum3_0_reg <= 16'd0;
            sum3_1_reg <= 16'd0;
        end else if (mul_en_pipe[1]) begin
            sum3_0_reg <= sum2_0_reg + sum2_1_reg;
            sum3_1_reg <= sum2_2_reg + sum2_3_reg;
        end else begin
            sum3_0_reg <= 16'd0;
            sum3_1_reg <= 16'd0;
        end
    end

    // Stage 4: final sum and register output when mul_en_pipe[2] is high
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'd0;
        end else if (mul_en_pipe[2]) begin
            mul_out_reg <= sum3_0_reg + sum3_1_reg;
        end else begin
            mul_out_reg <= 16'd0;
        end
    end

    // Output enable derived from last stage of mul_en_pipe
    assign mul_en_out = mul_en_pipe[3];

    // Output product valid only when mul_en_out active; else zero
    assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule
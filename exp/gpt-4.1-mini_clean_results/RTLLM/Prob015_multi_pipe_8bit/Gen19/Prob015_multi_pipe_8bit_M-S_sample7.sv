module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline stage enables (4-stage pipeline)
    reg [3:0] mul_en_pipe;

    // Stage 1 registers: input latching
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Stage 2 wires: partial products (16-bit)
    wire [15:0] pp[7:0];
    
    // Stage 3 registers: intermediate sums
    reg [15:0] sum_level1_0, sum_level1_1, sum_level1_2, sum_level1_3;
    reg [15:0] sum_level2_0, sum_level2_1;
    reg [15:0] sum_level3;

    // Stage 4 register: final product
    reg [15:0] mul_out_reg;

    integer i;

    // Stage 1: input sampling and enable pipeline
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

    // Stage 2: partial product generation
    generate
        genvar idx;
        for (idx = 0; idx < 8; idx = idx +1) begin : gen_pp
            assign pp[idx] = mul_b_reg[idx] ? (mul_a_reg << idx) : 16'd0;
        end
    endgenerate

    // Stage 3: balanced addition pipeline
    // Level 1: add pairs of partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_level1_0 <= 16'd0;
            sum_level1_1 <= 16'd0;
            sum_level1_2 <= 16'd0;
            sum_level1_3 <= 16'd0;
        end else if (mul_en_pipe[1]) begin
            sum_level1_0 <= pp[0] + pp[1];
            sum_level1_1 <= pp[2] + pp[3];
            sum_level1_2 <= pp[4] + pp[5];
            sum_level1_3 <= pp[6] + pp[7];
        end else begin
            sum_level1_0 <= 16'd0;
            sum_level1_1 <= 16'd0;
            sum_level1_2 <= 16'd0;
            sum_level1_3 <= 16'd0;
        end
    end

    // Level 2: add pairs of sums from level 1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_level2_0 <= 16'd0;
            sum_level2_1 <= 16'd0;
        end else if (mul_en_pipe[2]) begin
            sum_level2_0 <= sum_level1_0 + sum_level1_1;
            sum_level2_1 <= sum_level1_2 + sum_level1_3;
        end else begin
            sum_level2_0 <= 16'd0;
            sum_level2_1 <= 16'd0;
        end
    end

    // Level 3: final sum of level 2 results
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_level3 <= 16'd0;
        end else if (mul_en_pipe[3]) begin
            sum_level3 <= sum_level2_0 + sum_level2_1;
        end else begin
            sum_level3 <= 16'd0;
        end
    end

    // Stage 4: register final product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'd0;
        end else begin
            mul_out_reg <= sum_level3;
        end
    end

    // Output enable corresponds to stage 4 enable pipe
    assign mul_en_out = mul_en_pipe[3];

    // Output mux: valid product or zero
    assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule
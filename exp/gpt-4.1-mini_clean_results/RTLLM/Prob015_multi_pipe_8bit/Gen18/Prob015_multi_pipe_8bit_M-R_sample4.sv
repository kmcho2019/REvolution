module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

    // Stage 1 registers: latch inputs and input enable
    reg [7:0] mul_a_reg, mul_b_reg;
    reg       mul_en_stage1;

    // Partial products wires
    wire [15:0] pp[7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_pp
            assign pp[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
        end
    endgenerate

    // Stage 2 registers: sum pairs of partial products and enable
    reg [15:0] sum_stage2 [3:0];
    reg        mul_en_stage2;

    wire [15:0] sum_pairs [3:0];
    // Sum pairs of partial products combinationally
    assign sum_pairs[0] = pp[0] + pp[1];
    assign sum_pairs[1] = pp[2] + pp[3];
    assign sum_pairs[2] = pp[4] + pp[5];
    assign sum_pairs[3] = pp[6] + pp[7];

    // Stage 3 registers: sum sums from stage 2 and enable
    reg [15:0] sum_stage3 [1:0];
    reg        mul_en_stage3;

    wire [15:0] sum_stage3_wires [1:0];
    assign sum_stage3_wires[0] = sum_stage2[0] + sum_stage2[1];
    assign sum_stage3_wires[1] = sum_stage2[2] + sum_stage2[3];

    // Stage 4 registers: final product and enable
    reg [15:0] mul_out_reg;
    reg        mul_en_stage4;

    wire [15:0] final_sum;
    assign final_sum = sum_stage3[0] + sum_stage3[1];

    // Stage 1: latch inputs and input enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg     <= 8'd0;
            mul_b_reg     <= 8'd0;
            mul_en_stage1 <= 1'b0;
        end else begin
            mul_en_stage1 <= mul_en_in;
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // Stage 2: register partial sum pairs and enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage2[0] <= 16'd0;
            sum_stage2[1] <= 16'd0;
            sum_stage2[2] <= 16'd0;
            sum_stage2[3] <= 16'd0;
            mul_en_stage2 <= 1'b0;
        end else begin
            sum_stage2[0] <= sum_pairs[0];
            sum_stage2[1] <= sum_pairs[1];
            sum_stage2[2] <= sum_pairs[2];
            sum_stage2[3] <= sum_pairs[3];
            mul_en_stage2 <= mul_en_stage1;
        end
    end

    // Stage 3: register sums of sums and enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage3[0] <= 16'd0;
            sum_stage3[1] <= 16'd0;
            mul_en_stage3 <= 1'b0;
        end else begin
            sum_stage3[0] <= sum_stage3_wires[0];
            sum_stage3[1] <= sum_stage3_wires[1];
            mul_en_stage3 <= mul_en_stage2;
        end
    end

    // Stage 4: register final product and enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg   <= 16'd0;
            mul_en_stage4 <= 1'b0;
        end else begin
            mul_out_reg   <= final_sum;
            mul_en_stage4 <= mul_en_stage3;
        end
    end

    // Output enable and output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_out <= 1'b0;
        else
            mul_en_out <= mul_en_stage4;
    end

    always @(*) begin
        mul_out = mul_en_out ? mul_out_reg : 16'd0;
    end

endmodule
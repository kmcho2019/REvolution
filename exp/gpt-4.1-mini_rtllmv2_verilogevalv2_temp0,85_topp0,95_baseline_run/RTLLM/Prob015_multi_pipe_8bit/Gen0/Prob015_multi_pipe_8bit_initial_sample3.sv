module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input  [7:0]    mul_a,
    input  [7:0]    mul_b,
    output          mul_en_out,
    output [15:0]   mul_out
);

    // Pipeline stage 1 registers: sample inputs and enable
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;
    reg       mul_en_reg1;

    // Partial products wires (8 partial products, each shifted)
    wire [15:0] temp [7:0];
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : gen_temp
            assign temp[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'b0;
        end
    endgenerate

    // Pipeline stage 2 registers: sum partial products in pairs
    reg [15:0] sum_stage2_0;
    reg [15:0] sum_stage2_1;
    reg [15:0] sum_stage2_2;
    reg [15:0] sum_stage2_3;
    reg        mul_en_reg2;

    // Pipeline stage 3 registers: sum pairs from stage 2
    reg [15:0] sum_stage3_0;
    reg [15:0] sum_stage3_1;
    reg        mul_en_reg3;

    // Pipeline stage 4 register: final sum
    reg [15:0] mul_out_reg;
    reg        mul_en_reg4;

    // Output enable from last pipeline stage
    assign mul_en_out = mul_en_reg4;

    // Output product, zero if enable low
    assign mul_out = mul_en_reg4 ? mul_out_reg : 16'b0;

    // Pipeline logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg    <= 8'd0;
            mul_b_reg    <= 8'd0;
            mul_en_reg1  <= 1'b0;

            sum_stage2_0 <= 16'd0;
            sum_stage2_1 <= 16'd0;
            sum_stage2_2 <= 16'd0;
            sum_stage2_3 <= 16'd0;
            mul_en_reg2  <= 1'b0;

            sum_stage3_0 <= 16'd0;
            sum_stage3_1 <= 16'd0;
            mul_en_reg3  <= 1'b0;

            mul_out_reg  <= 16'd0;
            mul_en_reg4  <= 1'b0;
        end else begin
            // Stage 1: sample inputs when enable active
            if (mul_en_in) begin
                mul_a_reg   <= mul_a;
                mul_b_reg   <= mul_b;
            end
            mul_en_reg1 <= mul_en_in;

            // Stage 2: sum partial products pairwise
            // Only update if previous stage enable is high
            if (mul_en_reg1) begin
                sum_stage2_0 <= temp[0] + temp[1];
                sum_stage2_1 <= temp[2] + temp[3];
                sum_stage2_2 <= temp[4] + temp[5];
                sum_stage2_3 <= temp[6] + temp[7];
            end else begin
                sum_stage2_0 <= 16'd0;
                sum_stage2_1 <= 16'd0;
                sum_stage2_2 <= 16'd0;
                sum_stage2_3 <= 16'd0;
            end
            mul_en_reg2 <= mul_en_reg1;

            // Stage 3: sum pairs from stage 2
            if (mul_en_reg2) begin
                sum_stage3_0 <= sum_stage2_0 + sum_stage2_1;
                sum_stage3_1 <= sum_stage2_2 + sum_stage2_3;
            end else begin
                sum_stage3_0 <= 16'd0;
                sum_stage3_1 <= 16'd0;
            end
            mul_en_reg3 <= mul_en_reg2;

            // Stage 4: final sum
            if (mul_en_reg3) begin
                mul_out_reg <= sum_stage3_0 + sum_stage3_1;
            end else begin
                mul_out_reg <= 16'd0;
            end
            mul_en_reg4 <= mul_en_reg3;
        end
    end

endmodule
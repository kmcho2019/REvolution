module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

    // Stage 1 registers
    reg [7:0]  mul_a_reg;
    reg [7:0]  mul_b_reg;
    reg        en_stage1;

    // Partial products wires (16-bit each)
    wire [15:0] pp [7:0];

    // Stage 2 registers: sums of partial products (4 x 16-bit)
    reg [15:0] sum_stage2 [3:0];
    reg        en_stage2;

    // Stage 3 registers: sums of stage 2 outputs (2 x 16-bit)
    reg [15:0] sum_stage3 [1:0];
    reg        en_stage3;

    // Stage 4 registers: final product
    reg [15:0] sum_stage4;
    reg        en_stage4;

    integer i;

    // Stage 1: Register inputs and enable; generate partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
            en_stage1 <= 1'b0;
        end else begin
            en_stage1 <= mul_en_in;
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // Generate partial products: each is mul_a_reg shifted left by bit idx if mul_b_reg[idx] is 1, else zero
    // This is combinational logic
    generate
        genvar idx;
        for (idx = 0; idx < 8; idx = idx +1) begin : gen_pp
            assign pp[idx] = mul_b_reg[idx] ? ( {8'd0, mul_a_reg} << idx ) : 16'd0;
        end
    endgenerate

    // Stage 2: Add partial products pairwise: (pp0+pp1), (pp2+pp3), (pp4+pp5), (pp6+pp7)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i=0; i<4; i=i+1)
                sum_stage2[i] <= 16'd0;
            en_stage2 <= 1'b0;
        end else begin
            en_stage2 <= en_stage1;
            if (en_stage1) begin
                sum_stage2[0] <= pp[0] + pp[1];
                sum_stage2[1] <= pp[2] + pp[3];
                sum_stage2[2] <= pp[4] + pp[5];
                sum_stage2[3] <= pp[6] + pp[7];
            end else begin
                for (i=0; i<4; i=i+1)
                    sum_stage2[i] <= 16'd0;
            end
        end
    end

    // Stage 3: Add sums pairwise: (sum_stage2[0]+sum_stage2[1]) and (sum_stage2[2]+sum_stage2[3])
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage3[0] <= 16'd0;
            sum_stage3[1] <= 16'd0;
            en_stage3 <= 1'b0;
        end else begin
            en_stage3 <= en_stage2;
            if (en_stage2) begin
                sum_stage3[0] <= sum_stage2[0] + sum_stage2[1];
                sum_stage3[1] <= sum_stage2[2] + sum_stage2[3];
            end else begin
                sum_stage3[0] <= 16'd0;
                sum_stage3[1] <= 16'd0;
            end
        end
    end

    // Stage 4: Add the final two sums to get product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage4 <= 16'd0;
            en_stage4 <= 1'b0;
        end else begin
            en_stage4 <= en_stage3;
            if (en_stage3)
                sum_stage4 <= sum_stage3[0] + sum_stage3[1];
            else
                sum_stage4 <= 16'd0;
        end
    end

    // Output registered enable and product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out <= 1'b0;
            mul_out <= 16'd0;
        end else begin
            mul_en_out <= en_stage4;
            mul_out <= en_stage4 ? sum_stage4 : 16'd0;
        end
    end

endmodule
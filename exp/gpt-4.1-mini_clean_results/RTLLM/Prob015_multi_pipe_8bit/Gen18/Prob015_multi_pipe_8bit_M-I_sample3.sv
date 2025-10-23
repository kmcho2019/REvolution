module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

// Stage 1 registers: input capture and partial product generation
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg       mul_en_s1;

// Partial products (8x16 bits)
wire [15:0] partial_products [7:0];
genvar i;
generate
    for (i=0; i<8; i=i+1) begin : gen_partial_products
        assign partial_products[i] = (mul_en_s1 && mul_b_reg[i]) ? (mul_a_reg << i) : 16'd0;
    end
endgenerate

// Stage 2 registers: sum partial products in pairs (reduce 8 -> 4)
reg [15:0] sum_stage2 [3:0];
reg        mul_en_s2;

integer j;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
        mul_en_s1 <= 1'b0;
        for (j = 0; j < 4; j=j+1)
            sum_stage2[j] <= 16'd0;
        mul_en_s2 <= 1'b0;
    end else begin
        // Capture inputs and enable
        mul_en_s1 <= mul_en_in;
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end

        // Sum partial products pairs
        sum_stage2[0] <= partial_products[0] + partial_products[1];
        sum_stage2[1] <= partial_products[2] + partial_products[3];
        sum_stage2[2] <= partial_products[4] + partial_products[5];
        sum_stage2[3] <= partial_products[6] + partial_products[7];
        mul_en_s2 <= mul_en_s1;
    end
end

// Stage 3 registers: sum four sums into final product and register output enable
reg [15:0] sum_stage3 [1:0];
reg        mul_en_s3;
reg [15:0] mul_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage3[0] <= 16'd0;
        sum_stage3[1] <= 16'd0;
        mul_en_s3     <= 1'b0;
        mul_out_reg   <= 16'd0;
        mul_en_out    <= 1'b0;
        mul_out       <= 16'd0;
    end else begin
        // Sum stage 2 pairs
        sum_stage3[0] <= sum_stage2[0] + sum_stage2[1];
        sum_stage3[1] <= sum_stage2[2] + sum_stage2[3];
        mul_en_s3     <= mul_en_s2;

        // Final sum and output register
        mul_out_reg   <= sum_stage3[0] + sum_stage3[1];
        mul_en_out    <= mul_en_s3;
        mul_out       <= mul_en_s3 ? mul_out_reg : 16'd0;
    end
end

endmodule
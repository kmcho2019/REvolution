module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

// Stage 1 registers: capture inputs and enable
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg       mul_en_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg  <= 8'd0;
        mul_b_reg  <= 8'd0;
        mul_en_reg <= 1'b0;
    end else begin
        mul_en_reg <= mul_en_in;
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end
end

// Generate partial products combinationally
wire [15:0] partial_products [7:0];
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
        assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
    end
endgenerate

// Stage 2: first level of partial sum registers - sum partial products pairwise (4 sums)
reg [15:0] sum_stage2 [3:0];
reg        en_stage2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage2[0] <= 16'd0;
        sum_stage2[1] <= 16'd0;
        sum_stage2[2] <= 16'd0;
        sum_stage2[3] <= 16'd0;
        en_stage2     <= 1'b0;
    end else begin
        if (mul_en_reg) begin
            sum_stage2[0] <= partial_products[0] + partial_products[1];
            sum_stage2[1] <= partial_products[2] + partial_products[3];
            sum_stage2[2] <= partial_products[4] + partial_products[5];
            sum_stage2[3] <= partial_products[6] + partial_products[7];
        end else begin
            sum_stage2[0] <= 16'd0;
            sum_stage2[1] <= 16'd0;
            sum_stage2[2] <= 16'd0;
            sum_stage2[3] <= 16'd0;
        end
        en_stage2 <= mul_en_reg;
    end
end

// Stage 3: second level of partial sum registers - sum the four stage2 sums pairwise (2 sums)
reg [15:0] sum_stage3 [1:0];
reg        en_stage3;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage3[0] <= 16'd0;
        sum_stage3[1] <= 16'd0;
        en_stage3     <= 1'b0;
    end else begin
        if (en_stage2) begin
            sum_stage3[0] <= sum_stage2[0] + sum_stage2[1];
            sum_stage3[1] <= sum_stage2[2] + sum_stage2[3];
        end else begin
            sum_stage3[0] <= 16'd0;
            sum_stage3[1] <= 16'd0;
        end
        en_stage3 <= en_stage2;
    end
end

// Stage 4: final output register - sum the two stage3 sums
reg [15:0] mul_out_reg;
reg        en_stage4;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out_reg <= 16'd0;
        en_stage4   <= 1'b0;
    end else begin
        if (en_stage3) begin
            mul_out_reg <= sum_stage3[0] + sum_stage3[1];
        end else begin
            mul_out_reg <= 16'd0;
        end
        en_stage4 <= en_stage3;
    end
end

// Output assignment: output enable and product gated by enable
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out <= 1'b0;
        mul_out    <= 16'd0;
    end else begin
        mul_en_out <= en_stage4;
        mul_out    <= en_stage4 ? mul_out_reg : 16'd0;
    end
end

endmodule
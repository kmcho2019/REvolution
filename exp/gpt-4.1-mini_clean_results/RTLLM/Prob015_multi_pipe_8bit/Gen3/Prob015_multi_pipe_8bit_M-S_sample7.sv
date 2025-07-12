module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

// Pipeline register for input enable and operands
reg       mul_en_d1;
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;

// Partial products wires
wire [15:0] partial_products [7:0];

// Sum registers for partial sums
reg [15:0] sum_stage1;
reg [15:0] sum_stage2;

// Final product register
reg [15:0] mul_out_reg;

// Stage 1: capture inputs when enabled
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_d1 <= 1'b0;
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
    end else begin
        mul_en_d1 <= mul_en_in;
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end
end

// Generate partial products: mul_a_reg shifted by bit position i if mul_b_reg[i] is set
genvar i;
generate
    for (i=0; i<8; i=i+1) begin : gen_partial_products
        assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
    end
endgenerate

// Stage 2: sum partial products 0..3
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage1 <= 16'd0;
    end else if (mul_en_d1) begin
        sum_stage1 <= partial_products[0] + partial_products[1] + partial_products[2] + partial_products[3];
    end else begin
        sum_stage1 <= 16'd0;
    end
end

// Stage 3: sum partial products 4..7
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage2 <= 16'd0;
    end else if (mul_en_d1) begin
        sum_stage2 <= partial_products[4] + partial_products[5] + partial_products[6] + partial_products[7];
    end else begin
        sum_stage2 <= 16'd0;
    end
end

// Stage 4: final sum and output enable pipeline
reg mul_en_d2;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_d2   <= 1'b0;
        mul_out_reg <= 16'd0;
    end else begin
        mul_en_d2 <= mul_en_d1;
        if (mul_en_d1) begin
            mul_out_reg <= sum_stage1 + sum_stage2;
        end else begin
            mul_out_reg <= 16'd0;
        end
    end
end

// Output assignments
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out <= 1'b0;
        mul_out    <= 16'd0;
    end else begin
        mul_en_out <= mul_en_d2;
        mul_out    <= mul_en_d2 ? mul_out_reg : 16'd0;
    end
end

endmodule
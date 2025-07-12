module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

// Pipeline stage registers for enables
reg [4:0] mul_en_out_reg;

// Input registers for multiplicand and multiplier
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;

// Partial products wires (8 partial products of width 16 bits)
wire [15:0] partial[7:0];

// Registers for partial sums at intermediate stages
reg [15:0] sum_stage1; // Sum of partial[0] and partial[1]
reg [15:0] sum_stage2; // Sum of partial[2] and partial[3]
reg [15:0] sum_stage3; // Sum of partial[4] and partial[5]
reg [15:0] sum_stage4; // Sum of partial[6] and partial[7]

reg [15:0] sum_stage12;  // Sum of sum_stage1 and sum_stage2
reg [15:0] sum_stage34;  // Sum of sum_stage3 and sum_stage4

reg [15:0] mul_out_reg;

// Input enable pipeline
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        mul_en_out_reg <= 5'd0;
    else
        mul_en_out_reg <= {mul_en_out_reg[3:0], mul_en_in};
end

assign mul_en_out = mul_en_out_reg[4];

// Input registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end
end

// Partial product generation (each partial product is multiplicand ANDed with one multiplier bit, shifted accordingly)
genvar i;
generate
    for (i=0; i<8; i=i+1) begin : gen_partial_products
        assign partial[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
    end
endgenerate

// Pipeline stage 1: sum pairs of partial products (0+1), (2+3), (4+5), (6+7)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage1 <= 16'd0;
        sum_stage2 <= 16'd0;
        sum_stage3 <= 16'd0;
        sum_stage4 <= 16'd0;
    end else begin
        sum_stage1 <= partial[0] + partial[1];
        sum_stage2 <= partial[2] + partial[3];
        sum_stage3 <= partial[4] + partial[5];
        sum_stage4 <= partial[6] + partial[7];
    end
end

// Pipeline stage 2: sum pairs of sums from stage 1: sum_stage1 + sum_stage2, sum_stage3 + sum_stage4
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage12 <= 16'd0;
        sum_stage34 <= 16'd0;
    end else begin
        sum_stage12 <= sum_stage1 + sum_stage2;
        sum_stage34 <= sum_stage3 + sum_stage4;
    end
end

// Pipeline stage 3: final sum to get the product
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        mul_out_reg <= 16'd0;
    else
        mul_out_reg <= sum_stage12 + sum_stage34;
end

// Output assignment
assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule
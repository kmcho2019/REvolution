module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

// Stage 0: Input registers
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg       mul_en_reg;

// Stage 1: Partial products registers
reg [15:0] partial_products_reg [7:0];
reg        mul_en_stage1;

// Stage 2: Intermediate sums registers
reg [15:0] sum_low_reg;
reg [15:0] sum_high_reg;
reg        mul_en_stage2;

// Stage 3: Final product register
reg [15:0] product_reg;
reg        mul_en_stage3;

// Generate partial products combinationally based on registered inputs
wire [15:0] partial_products_wire [7:0];
genvar i;
generate
    for (i=0; i<8; i=i+1) begin : gen_partial_products
        assign partial_products_wire[i] = (mul_en_reg && mul_b_reg[i]) ? (mul_a_reg << i) : 16'd0;
    end
endgenerate

// Stage 0: Capture inputs and enable
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

// Stage 1: Register partial products and enable
integer j;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (j=0; j<8; j=j+1)
            partial_products_reg[j] <= 16'd0;
        mul_en_stage1 <= 1'b0;
    end else begin
        for (j=0; j<8; j=j+1)
            partial_products_reg[j] <= partial_products_wire[j];
        mul_en_stage1 <= mul_en_reg;
    end
end

// Stage 2: Sum partial products in two groups and register
wire [15:0] sum_low = partial_products_reg[0] + partial_products_reg[1] + partial_products_reg[2] + partial_products_reg[3];
wire [15:0] sum_high = partial_products_reg[4] + partial_products_reg[5] + partial_products_reg[6] + partial_products_reg[7];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_low_reg  <= 16'd0;
        sum_high_reg <= 16'd0;
        mul_en_stage2 <= 1'b0;
    end else begin
        sum_low_reg  <= sum_low;
        sum_high_reg <= sum_high;
        mul_en_stage2 <= mul_en_stage1;
    end
end

// Stage 3: Final addition of intermediate sums and output registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        product_reg    <= 16'd0;
        mul_en_stage3  <= 1'b0;
        mul_en_out     <= 1'b0;
        mul_out        <= 16'd0;
    end else begin
        product_reg   <= sum_low_reg + sum_high_reg;
        mul_en_stage3 <= mul_en_stage2;

        mul_en_out <= mul_en_stage3;
        mul_out    <= mul_en_stage3 ? product_reg : 16'd0;
    end
end

endmodule
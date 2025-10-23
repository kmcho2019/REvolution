module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

// Pipeline registers for inputs and enable
reg         mul_en_pipe;
reg [7:0]   mul_a_reg;
reg [7:0]   mul_b_reg;

// Partial products wires
wire [15:0] partial_products [7:0];

// Generate partial products by AND and shift
genvar i;
generate
    for (i=0; i<8; i=i+1) begin : gen_partial_products
        assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
    end
endgenerate

// Sum all partial products combinationally
wire [15:0] sum_all = partial_products[0] + partial_products[1] + partial_products[2] +
                      partial_products[3] + partial_products[4] + partial_products[5] +
                      partial_products[6] + partial_products[7];

// Pipeline stage: sample inputs and enable
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_pipe <= 1'b0;
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
    end else begin
        mul_en_pipe <= mul_en_in;
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end
end

// Pipeline stage: register output product and output enable
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out <= 1'b0;
        mul_out <= 16'd0;
    end else begin
        mul_en_out <= mul_en_pipe;
        mul_out <= mul_en_pipe ? sum_all : 16'd0;
    end
end

endmodule
module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] stage1_reg;
reg [2*size-1:0] stage2_reg;

// Extend input signals by adding "size" number of zero bits at the most significant bit positions
wire [2*size-1:0] mul_a_ext = { {size{1'b0}}, mul_a };
wire [2*size-1:0] mul_b_ext = { {size{1'b0}}, mul_b };

// Perform multiplication for each bit position of the multiplier
wire [2*size-1:0] partial_products [size];
genvar i;
generate
    for (i = 0; i < size; i++) begin: partial_product_gen
        wire [2*size-1:0] shifted_mul_a = mul_a_ext << i;
        assign partial_products[i] = (mul_b_ext[i] == 1'b1) ? shifted_mul_a : {2*size{1'b0}};
    end
endgenerate

// Add partial products
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_reg <= {2*size{1'b0}};
    end else begin
        stage1_reg <= partial_products[0];
        for (int i = 1; i < size; i++) begin
            stage1_reg <= stage1_reg + partial_products[i];
        end
    end
end

// Final product calculation
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage2_reg <= {2*size{1'b0}};
        mul_out <= {2*size{1'b0}};
    end else begin
        stage2_reg <= stage1_reg;
        mul_out <= stage2_reg;
    end
end

endmodule
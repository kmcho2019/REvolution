module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

reg [2*size-1:0] partial_product [size-1:0];
reg [2*size-1:0] sum_reg1, sum_reg2;

// Extend input signals by adding zeros at the most significant bit positions
wire [2*size-1:0] mul_a_ext = { {size{1'b0}}, mul_a };
wire [2*size-1:0] mul_b_ext = { {size{1'b0}}, mul_b };

// Generate block to perform multiplication for each bit position of the multiplier
genvar i;
generate
    for (i = 0; i < size; i++) begin
        if (mul_b_ext[i]) begin
            assign partial_product[i] = mul_a_ext << i;
        end else begin
            assign partial_product[i] = 'd0;
        end
    end
endgenerate

// Add partial products using registers to store intermediate sum values
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg1 <= 'd0;
        sum_reg2 <= 'd0;
    end else begin
        sum_reg1 <= partial_product[0] + 'd0;
        for (i = 1; i < size; i++) begin
            sum_reg1 <= sum_reg1 + partial_product[i];
        end
        sum_reg2 <= sum_reg1;
    end
end

// Calculate final product
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= 'd0;
    end else begin
        mul_out <= sum_reg2;
    end
end

endmodule
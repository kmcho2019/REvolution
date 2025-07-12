module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

reg [2*size-1:0] partial_products [size];
reg [2*size-1:0] sum1, sum2;

// Extend input signals by adding size number of zero bits at the most significant bit positions
wire [2*size-1:0] ext_a = { {size{1'b0}}, mul_a };
wire [2*size-1:0] ext_b = { {size{1'b0}}, mul_b };

// Generate partial products for each bit position of the multiplier
genvar i;
generate
    for (i = 0; i < size; i++) begin
        if (mul_b[i]) begin
            assign partial_products[i] = ext_a << i;
        end else begin
            assign partial_products[i] = 'd0;
        end
    end
endgenerate

// Add partial products
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum1 <= 'd0;
    end else begin
        sum1 <= partial_products[0];
        for (i = 1; i < size; i++) begin
            sum1 <= sum1 + partial_products[i];
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum2 <= 'd0;
    end else begin
        sum2 <= sum1;
    end
end

// Calculate final product
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= 'd0;
    end else begin
        mul_out <= sum2;
    end
end

endmodule
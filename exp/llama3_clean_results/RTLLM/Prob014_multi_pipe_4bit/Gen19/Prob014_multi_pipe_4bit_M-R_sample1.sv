module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] extended_mul_a;
reg [2*size-1:0] partial_sum;
reg [2*size-1:0] final_product;

// Generate partial products
wire [2*size-1:0] partial_products [size-1:0];
genvar i;
generate
    for (i = 0; i < size; i++) begin
        assign partial_products[i] = (mul_b[i] == 1'b1)? (mul_a << i) : {2*size{1'b0}};
    end
endgenerate

// Sum partial products
reg [2*size-1:0] sum;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum <= {2*size{1'b0}};
    end else begin
        sum <= {2*size{1'b0}};
        for (int j = 0; j < size; j++) begin
            sum = sum + partial_products[j];
        end
    end
end

// Update registers
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        partial_sum <= {2*size{1'b0}};
        final_product <= {2*size{1'b0}};
        mul_out <= {2*size{1'b0}};
    end else begin
        partial_sum <= sum;
        final_product <= partial_sum;
        mul_out <= final_product;
    end
end

endmodule
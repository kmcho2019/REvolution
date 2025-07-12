module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

// Intermediate signals
reg [2*size-1:0] partial_products [size-1:0];
reg [2*size-1:0] sum_registers [size-1:0];

// First stage: calculate partial products
genvar i;
generate
    for (i = 0; i < size; i++) begin: partial_product_gen
        if (i == 0) begin
            assign partial_products[i] = {size{1'b0}} << size | (mul_b[i]? mul_a : {size{1'b0}});
        end else begin
            assign partial_products[i] = {size{1'b0}} << (size + i) | (mul_b[i]? mul_a << i : {size{1'b0}});
        end
    end
endgenerate

// Second stage: add partial products
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (int i = 0; i < size; i++) begin
            sum_registers[i] <= {2*size{1'b0}};
        end
    end else begin
        sum_registers[0] <= partial_products[0];
        for (int i = 1; i < size; i++) begin
            sum_registers[i] <= sum_registers[i-1] + partial_products[i];
        end
    end
end

// Third stage: calculate final product
reg [2*size-1:0] final_product;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        final_product <= {2*size{1'b0}};
    end else begin
        final_product <= sum_registers[size-1];
    end
end

assign mul_out = final_product;

endmodule
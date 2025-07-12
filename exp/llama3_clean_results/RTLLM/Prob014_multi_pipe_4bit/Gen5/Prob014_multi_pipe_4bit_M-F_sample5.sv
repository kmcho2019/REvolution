module pe #(
    parameter size = 4
)(
    input [size-1:0] multiplicand,
    input [2*size-1:0] partial_product,
    input multiplier_bit,
    output reg [2*size-1:0] result
);
    always @(*) begin
        if (multiplier_bit == 1'b1) begin
            result = partial_product + ({size{1'b0}}, multiplicand);
        end else begin
            result = partial_product;
        end
    end
endmodule

module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] partial_product [size];
reg [2*size-1:0] reg1;
reg [2*size-1:0] reg2;

genvar i;
generate
    for (i = 0; i < size; i++) begin
        if (i == 0) begin
            pe pe_i (
               .multiplicand(mul_a),
               .partial_product({size{1'b0}}),
               .multiplier_bit(mul_b[i]),
               .result(partial_product[i])
            );
        end else begin
            pe pe_i (
               .multiplicand(mul_a),
               .partial_product(partial_product[i-1]),
               .multiplier_bit(mul_b[i]),
               .result(partial_product[i])
            );
        end
    end
endgenerate

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg1 <= {2*size{1'b0}};
        reg2 <= {2*size{1'b0}};
        mul_out <= {2*size{1'b0}};
    end else begin
        reg1 <= partial_product[0];
        for (int i = 1; i < size; i++) begin
            reg2 <= reg1 + partial_product[i];
            reg1 <= reg2;
        end
        mul_out <= reg2;
    end
end

endmodule
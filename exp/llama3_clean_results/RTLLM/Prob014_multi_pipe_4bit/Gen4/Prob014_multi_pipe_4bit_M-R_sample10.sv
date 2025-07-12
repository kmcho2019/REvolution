module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Processing Element (PE) module
module pe(
    input [size-1:0] multiplicand,
    input [2*size-1:0] partial_product,
    input multiplier_bit,
    output reg [2*size-1:0] result
);
    always @(*) begin
        if (multiplier_bit == 1'b1) begin
            result = partial_product + (multiplicand << 1);
        end else begin
            result = partial_product;
        end
    end
endmodule

// Systolic Array
reg [2*size-1:0] partial_product [size];
wire [2*size-1:0] pe_out [size-1:0];

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

// Output Stage
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= {2*size{1'b0}};
    end else begin
        mul_out <= partial_product[size-1];
    end
end

endmodule
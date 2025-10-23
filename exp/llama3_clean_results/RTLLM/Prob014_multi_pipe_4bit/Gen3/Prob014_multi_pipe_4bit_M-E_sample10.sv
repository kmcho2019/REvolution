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
    input multiplicand_shift,
    input [size-1:0] multiplier_bit,
    input [2*size-1:0] partial_product,
    output reg [2*size-1:0] result
);
    always @(*) begin
        if (multiplier_bit == 1'b1) begin
            result = partial_product + (multiplicand << multiplicand_shift);
        end else begin
            result = partial_product;
        end
    end
endmodule

// Systolic Array
reg [2*size-1:0] partial_product [size];

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (int i = 0; i < size; i++) begin
            partial_product[i] <= {2*size{1'b0}};
        end
    end else begin
        partial_product[0] <= (mul_b[0] == 1'b1) ? {size{1'b0}} + mul_a : {2*size{1'b0}};
        for (int i = 1; i < size; i++) begin
            pe pe_i (
                .multiplicand(mul_a),
                .multiplicand_shift(i),
                .multiplier_bit(mul_b[i]),
                .partial_product(partial_product[i-1]),
                .result(partial_product[i])
            );
        end
    end
end

// Output Stage
always @(posedge clk) begin
    mul_out <= partial_product[size-1];
end

endmodule
module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] partial_sum;
reg [2*size-1:0] final_product;

// Generate block to perform multiplication for each bit position of the multiplier
generate
    for (genvar i = 0; i < size; i++) begin
        wire [2*size-1:0] partial_product;
        assign partial_product = (mul_b[i] == 1'b1) ? (mul_a << i) : {2*size{1'b0}};
        if (i == 0) begin
            assign partial_sum = partial_product;
        end else begin
            reg [2*size-1:0] sum;
            always @(posedge clk or negedge rst_n) begin
                if (~rst_n) begin
                    sum <= {2*size{1'b0}};
                end else begin
                    sum <= partial_sum + partial_product;
                end
            end
            assign partial_sum = sum;
        end
    end
endgenerate

// Update final product
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        final_product <= {2*size{1'b0}};
    end else begin
        final_product <= partial_sum;
    end
end

// Update output
always @(posedge clk) begin
    if (rst_n) begin
        mul_out <= final_product;
    end else begin
        mul_out <= {2*size{1'b0}};
    end
end

endmodule
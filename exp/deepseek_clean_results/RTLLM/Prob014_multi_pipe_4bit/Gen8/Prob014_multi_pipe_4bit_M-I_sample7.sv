module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Pipeline stage 1: Partial product generation
reg [2*size-1:0] partial_products [0:size-1];
genvar i;
generate
    for (i = 0; i < size; i = i + 1) begin : PP_GEN
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                partial_products[i] <= {(2*size){1'b0}};
            end else begin
                partial_products[i] <= mul_b[i] ? ({size{1'b0}, mul_a} << i) : {(2*size){1'b0}};
            end
        end
    end
endgenerate

// Pipeline stage 2: Balanced adder tree
reg [2*size-1:0] sum_01, sum_23;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_01 <= {(2*size){1'b0}};
        sum_23 <= {(2*size){1'b0}};
        mul_out <= {(2*size){1'b0}};
    end else begin
        sum_01 <= partial_products[0] + partial_products[1];
        sum_23 <= partial_products[2] + partial_products[3];
        mul_out <= sum_01 + sum_23;
    end
end

endmodule
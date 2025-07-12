module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;

reg [7:0] partial_product;
reg [7:0] intermediate_sum_1;
reg [7:0] intermediate_sum_2;

// Extend input signals by adding "size" number of zero bits at the most significant bit positions
reg [7:0] extended_mul_a;
reg [7:0] extended_mul_b;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        extended_mul_a <= 8'd0;
        extended_mul_b <= 8'd0;
    end else begin
        extended_mul_a <= {4'd0, mul_a};
        extended_mul_b <= {4'd0, mul_b};
    end
end

// Generate partial products
genvar i;
generate
    for (i = 0; i < size; i++) begin
        always @(posedge clk or negedge rst_n) begin
            if (~rst_n) begin
                partial_product[i +: 4] <= 4'd0;
            end else if (extended_mul_b[i]) begin
                partial_product[i +: 4] <= extended_mul_a << i;
            end else begin
                partial_product[i +: 4] <= 4'd0;
            end
        end
    end
endgenerate

// Store intermediate sum values and perform add operations
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        intermediate_sum_1 <= 8'd0;
    end else begin
        intermediate_sum_1 <= partial_product;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        intermediate_sum_2 <= 8'd0;
    end else begin
        intermediate_sum_2 <= intermediate_sum_1;
    end
end

// Calculate final product
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= 8'd0;
    end else begin
        mul_out <= intermediate_sum_2;
    end
end

endmodule
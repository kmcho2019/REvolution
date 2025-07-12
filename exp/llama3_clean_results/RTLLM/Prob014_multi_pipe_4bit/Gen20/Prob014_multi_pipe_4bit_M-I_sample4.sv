module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Extension Stage
reg [2*size-1:0] extended_mul_a;
reg [2*size-1:0] extended_mul_b;
always @(*) begin
    extended_mul_a = {size{1'b0}} | {size{1'b0}, mul_a};
    extended_mul_b = {size{1'b0}} | {size{1'b0}, mul_b};
end

// Partial Product Generation Stage
reg [2*size-1:0] partial_products [size-1:0];
always @(*) begin
    for (int i = 0; i < size; i++) begin
        if (mul_b[i] == 1'b1) begin
            partial_products[i] = extended_mul_a << i;
        end else begin
            partial_products[i] = {2*size{1'b0}};
        end
    end
end

// Summation Stage
reg [2*size-1:0] sum1;
reg [2*size-1:0] sum2;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum1 <= {2*size{1'b0}};
        sum2 <= {2*size{1'b0}};
    end else begin
        sum1 <= partial_products[0];
        for (int i = 1; i < size; i++) begin
            sum1 <= sum1 + partial_products[i];
        end
        sum2 <= sum1;
    end
end

// Output Stage
always @(posedge clk) begin
    mul_out <= sum2;
end

endmodule
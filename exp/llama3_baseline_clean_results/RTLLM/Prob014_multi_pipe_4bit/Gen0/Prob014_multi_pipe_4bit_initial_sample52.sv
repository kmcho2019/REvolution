module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output [7:0] mul_out
);

parameter size = 4;

reg [7:0] partial_products [3:0];
reg [7:0] sum1, sum2;

// Generate block to calculate partial products
genvar i;
generate
    for(i = 0; i < size; i++) begin
        always @(posedge clk or negedge rst_n) begin
            if(~rst_n) begin
                partial_products[i] <= 8'd0;
            end else if(mul_b[i]) begin
                partial_products[i] <= {4'd0, mul_a} << i;
            end else begin
                partial_products[i] <= 8'd0;
            end
        end
    end
endgenerate

// First level of registers to store sum of partial products
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        sum1 <= 8'd0;
    end else begin
        sum1 <= partial_products[0] + partial_products[1];
    end
end

// Second level of registers to store final product
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        sum2 <= 8'd0;
    end else begin
        sum2 <= sum1 + partial_products[2] + partial_products[3];
    end
end

// Final product output
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        mul_out <= 8'd0;
    end else begin
        mul_out <= sum2;
    end
end

endmodule
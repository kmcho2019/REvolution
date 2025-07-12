module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output [7:0] mul_out
);

reg [7:0] partial_products [3:0];
reg [7:0] sum1;
reg [7:0] sum2;

// Stage 1: Generate partial products
integer i;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (i = 0; i < 4; i++) begin
            partial_products[i] <= 8'd0;
        end
        sum1 <= 8'd0;
    end else begin
        for (i = 0; i < 4; i++) begin
            if (mul_b[i]) begin
                partial_products[i] <= {4'd0, mul_a} << i;
            end else begin
                partial_products[i] <= 8'd0;
            end
        end
    end
end

// Stage 2: Sum partial products
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum2 <= 8'd0;
    end else begin
        sum1 <= partial_products[0] + partial_products[1] + partial_products[2] + partial_products[3];
    end
end

// Final product calculation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= 8'd0;
    end else begin
        mul_out <= sum1;
    end
end

endmodule
module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output [7:0] mul_out
);

parameter size = 4;

reg [7:0] reg1;
reg [7:0] reg2;

wire [7:0] partial_product_0;
wire [7:0] partial_product_1;
wire [7:0] partial_product_2;
wire [7:0] partial_product_3;

// Generate block to perform multiplication for each bit position of the multiplier
generate
    for (genvar i = 0; i < size; i++) begin
        if (i == 0) begin
            assign partial_product_0 = (mul_b[0] == 1'b1) ? {4'b0, mul_a} : 8'd0;
        end else if (i == 1) begin
            assign partial_product_1 = (mul_b[1] == 1'b1) ? {3'b0, mul_a, 1'b0} : 8'd0;
        end else if (i == 2) begin
            assign partial_product_2 = (mul_b[2] == 1'b1) ? {2'b0, mul_a, 2'b0} : 8'd0;
        end else if (i == 3) begin
            assign partial_product_3 = (mul_b[3] == 1'b1) ? {1'b0, mul_a, 3'b0} : 8'd0;
        end
    end
endgenerate

// Add partial products and store in reg1
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg1 <= 8'd0;
    end else begin
        reg1 <= partial_product_0 + partial_product_1 + partial_product_2 + partial_product_3;
    end
end

// Add reg1 and reg2 to produce final product
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg2 <= 8'd0;
    end else begin
        reg2 <= reg1;
    end
end

// Assign final product to output
assign mul_out = reg2;

endmodule
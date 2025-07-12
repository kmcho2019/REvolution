module multi_pipe_4bit (
    input clk,  // clock signal
    input rst_n,  // active-low reset signal
    input [3:0] mul_a,  // input signal representing the multiplicand
    input [3:0] mul_b,  // input signal representing the multiplier
    output reg [7:0] mul_out  // product output signal
);

parameter size = 4;

// extend the input signals by adding "size" number of zero bits at the most significant bit positions
wire [7:0] mul_a_ext = {4'b0, mul_a};
wire [7:0] mul_b_ext = {4'b0, mul_b};

// generate the partial products for each bit position of the multiplier
reg [7:0] partial_product [3:0];

// calculate the partial products
always @(*) begin
    for (int i = 0; i < size; i++) begin
        if (mul_b_ext[i] == 1'b1) begin
            partial_product[i] = mul_a_ext << i;
        end else begin
            partial_product[i] = 8'd0;
        end
    end
end

// define the tree structure for summing the partial products
reg [7:0] sum_level1 [1:0];
reg [7:0] sum_level2;

// sum the partial products in pairs at the first level
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_level1[0] <= 8'd0;
        sum_level1[1] <= 8'd0;
    end else begin
        sum_level1[0] <= partial_product[0] + partial_product[1];
        sum_level1[1] <= partial_product[2] + partial_product[3];
    end
end

// sum the results from the first level at the second level
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_level2 <= 8'd0;
    end else begin
        sum_level2 <= sum_level1[0] + sum_level1[1];
    end
end

// output the final product
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 8'd0;
    end else begin
        mul_out <= sum_level2;
    end
end

endmodule
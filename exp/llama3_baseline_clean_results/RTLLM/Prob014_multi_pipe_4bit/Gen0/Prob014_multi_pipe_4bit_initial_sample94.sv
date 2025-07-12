module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output [7:0] mul_out
);

// Extension of input signals by adding "size" number of zero bits at the most significant bit positions
wire [7:0] a_extended = {4'd0, mul_a};
wire [7:0] b_extended = {4'd0, mul_b};

// Generate block to perform multiplication for each bit position of the multiplier
reg [7:0] partial_products [3:0];
reg [7:0] sum_reg1;
reg [7:0] sum_reg2;

integer i;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg1 <= 8'd0;
        sum_reg2 <= 8'd0;
        mul_out <= 8'd0;
        for (i = 0; i < 4; i++) begin
            partial_products[i] <= 8'd0;
        end
    end else begin
        // Calculate partial products
        for (i = 0; i < 4; i++) begin
            if (b_extended[i]) begin
                partial_products[i] <= a_extended << i;
            end else begin
                partial_products[i] <= 8'd0;
            end
        end
        
        // Add partial products and store in registers
        sum_reg1 <= partial_products[0] + partial_products[1];
        sum_reg2 <= partial_products[2] + partial_products[3];
        
        // Calculate final product
        mul_out <= sum_reg1 + sum_reg2;
    end
end

endmodule
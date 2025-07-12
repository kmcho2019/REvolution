module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

// Define the size of the multiplicand and multiplier
localparam size = 4;

// Declare the intermediate registers
reg [7:0] partial_product;
reg [7:0] partial_sum1;
reg [7:0] partial_sum2;

// Extend the multiplicand and multiplier by adding zero bits
reg [7:0] mul_a_ext;
reg [7:0] mul_b_ext;

// Initialize the extended signals
assign mul_a_ext = {4'd0, mul_a};
assign mul_b_ext = {4'd0, mul_b};

// Generate block for partial product calculation
integer i;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset the partial product and intermediate sums
        partial_product <= 8'd0;
        partial_sum1 <= 8'd0;
        partial_sum2 <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        // Calculate the partial product for each bit position of the multiplier
        for (i = 0; i < size; i++) begin
            if (mul_b_ext[i]) begin
                partial_product <= mul_a_ext << i;
            end else begin
                partial_product <= 8'd0;
            end
            // Update the intermediate sum1
            if (i == 0) begin
                partial_sum1 <= partial_product;
            end else begin
                partial_sum1 <= partial_sum1 + partial_product;
            end
        end
        // Update the intermediate sum2
        partial_sum2 <= partial_sum1;
        // Update the final product output
        mul_out <= partial_sum2;
    end
end

endmodule
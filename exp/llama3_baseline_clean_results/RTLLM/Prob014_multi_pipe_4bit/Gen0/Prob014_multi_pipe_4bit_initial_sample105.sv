module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

// Define local parameters
parameter size = 4;

// Define local signals
reg [7:0] partial_products [size-1:0];
reg [7:0] sum [size-1:0];
reg [7:0] final_sum;

// Initialize partial products to 0
integer i;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (i = 0; i < size; i++) begin
            partial_products[i] <= 8'b0;
        end
        sum <= 8'b0;
        final_sum <= 8'b0;
    end else begin
        // Extend input signals
        for (i = 0; i < size; i++) begin
            if (mul_b[i]) begin
                partial_products[i] <= {4'b0, mul_a} << i;
            end else begin
                partial_products[i] <= 8'b0;
            end
        end

        // Add partial products
        sum[0] <= partial_products[0];
        for (i = 1; i < size; i++) begin
            sum[i] <= sum[i-1] + partial_products[i];
        end

        // Calculate final product
        final_sum <= sum[size-1];
    end
end

// Update output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= 8'b0;
    end else begin
        mul_out <= final_sum;
    end
end

endmodule
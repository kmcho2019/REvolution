module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

// Extend input signals by adding zeros to the most significant bit positions
wire [2*size-1:0] extended_mul_a = { {size{1'b0}}, mul_a };

// Generate block to calculate partial products
reg [2*size-1:0] partial_products [size-1:0];

integer i;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset partial products
        for (i = 0; i < size; i++) begin
            partial_products[i] <= {2*size{1'b0}};
        end
    end else begin
        // Calculate partial products
        for (i = 0; i < size; i++) begin
            if (mul_b[i]) begin
                partial_products[i] <= extended_mul_a << i;
            end else begin
                partial_products[i] <= {2*size{1'b0}};
            end
        end
    end
end

// Registers to store intermediate sum values
reg [2*size-1:0] sum1, sum2;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset sum registers
        sum1 <= {2*size{1'b0}};
        sum2 <= {2*size{1'b0}};
    end else begin
        // Update sum registers
        sum1 <= partial_products[0] + partial_products[1];
        sum2 <= partial_products[2] + partial_products[3];
    end
end

// Calculate final product
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset product output
        mul_out <= {2*size{1'b0}};
    end else begin
        // Update product output
        mul_out <= sum1 + sum2;
    end
end

endmodule
module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] partial_products [size-1:0];
reg [2*size-1:0] sum_reg1;
reg [2*size-1:0] sum_reg2;

integer i;

// Extend input signals by adding "size" number of zero bits at the most significant bit positions
reg [2*size-1:0] extended_mul_a;
reg [2*size-1:0] extended_mul_b;

always @(posedge clk) begin
    extended_mul_a <= {size{1'b0}, mul_a};
    extended_mul_b <= {size{1'b0}, mul_b};
end

// Calculate partial products
always @(posedge clk) begin
    for (i = 0; i < size; i++) begin
        if (extended_mul_b[i] == 1'b1) begin
            partial_products[i] <= extended_mul_a << i;
        end else begin
            partial_products[i] <= {2*size{1'b0}};
        end
    end
end

// Calculate sum
always @(posedge clk) begin
    sum_reg1 <= {2*size{1'b0}};
    for (i = 0; i < size; i++) begin
        sum_reg1 <= sum_reg1 + partial_products[i];
    end
end

always @(posedge clk) begin
    sum_reg2 <= sum_reg1;
end

// Update output
always @(posedge clk) begin
    mul_out <= sum_reg2;
end

// Reset logic
always @(negedge rst_n) begin
    mul_out <= {2*size{1'b0}};
    sum_reg1 <= {2*size{1'b0}};
    sum_reg2 <= {2*size{1'b0}};
    for (i = 0; i < size; i++) begin
        partial_products[i] <= {2*size{1'b0}};
    end
end

endmodule
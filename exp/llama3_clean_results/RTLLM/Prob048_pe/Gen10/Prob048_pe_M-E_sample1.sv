module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

reg [63:0] product_reg;  // Register to store the product of a and b
reg [63:0] sum_reg;  // Register to store the sum of product and c_reg
reg [31:0] c_reg;  // Register to store the accumulated result

// Stage 1: Multiplication
always @(posedge clk) begin
    if (rst) begin
        product_reg <= 64'd0;
    end else begin
        product_reg <= a * b;
    end
end

// Stage 2: Addition
always @(posedge clk) begin
    if (rst) begin
        sum_reg <= 64'd0;
    end else begin
        sum_reg <= product_reg + {32'd0, c_reg};
    end
end

// Stage 3: Register Update
always @(posedge clk) begin
    if (rst) begin
        c_reg <= 32'd0;
    end else begin
        c_reg <= sum_reg[31:0];
    end
end

// Output assignment
assign c = c_reg;

endmodule
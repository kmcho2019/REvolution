module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

reg [31:0] a_reg, b_reg;  // Registered inputs
reg [31:0] product_reg;  // Registered product
reg [31:0] c_reg;  // Accumulator register

// Pipeline stage 1: Input registration
always @(posedge clk) begin
    if (rst) begin
        a_reg <= 32'd0;
        b_reg <= 32'd0;
    end else begin
        a_reg <= a;
        b_reg <= b;
    end
end

// Pipeline stage 2: Multiplication
always @(posedge clk) begin
    if (rst) begin
        product_reg <= 32'd0;
    end else begin
        product_reg <= a_reg * b_reg;
    end
end

// Pipeline stage 3: Accumulation
always @(posedge clk) begin
    if (rst) begin
        c_reg <= 32'd0;
    end else begin
        c_reg <= c_reg + product_reg;
    end
end

// Output assignment
assign c = c_reg;

endmodule
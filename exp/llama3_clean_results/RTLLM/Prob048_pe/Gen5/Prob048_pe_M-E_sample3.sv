module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

reg [31:0] c_reg;  // Register to store the accumulated result
reg [31:0] product;  // Register to store the product

// Barrel Shifter to align the multiplicand with the appropriate bit position
wire [31:0] shifted_b;
assign shifted_b = (b << a[0]);

// Array of Adders to accumulate the partial products
reg [31:0] partial_product;
always @(posedge clk) begin
    if (rst) begin
        partial_product <= 32'd0;
    end else begin
        partial_product <= partial_product + shifted_b;
    end
end

// Pipelined Accumulator to pipeline the accumulation process
reg [31:0] pipe_reg1;
reg [31:0] pipe_reg2;
always @(posedge clk) begin
    if (rst) begin
        pipe_reg1 <= 32'd0;
        pipe_reg2 <= 32'd0;
    end else begin
        pipe_reg1 <= partial_product;
        pipe_reg2 <= pipe_reg1 + c_reg;
    end
end

// Clock Gating to reduce unnecessary switching activity
reg clk_gated;
always @(posedge clk) begin
    if (rst) begin
        clk_gated <= 1'b0;
    end else if (a != 32'd0 || b != 32'd0) begin
        clk_gated <= 1'b1;
    end else begin
        clk_gated <= 1'b0;
    end
end

// Accumulate the product into the output register
always @(posedge clk) begin
    if (rst) begin
        c_reg <= 32'd0;
    end else if (clk_gated) begin
        c_reg <= pipe_reg2;
    end
end

assign c = c_reg;

endmodule
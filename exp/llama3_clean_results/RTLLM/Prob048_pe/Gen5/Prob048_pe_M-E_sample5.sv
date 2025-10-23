module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

// Stage 1: Operand Fetch and Alignment
reg [31:0] a_reg;
reg [31:0] b_reg;
always @(posedge clk) begin
    if (rst) begin
        a_reg <= 32'd0;
        b_reg <= 32'd0;
    end else begin
        a_reg <= a;
        b_reg <= b;
    end
end

// Stage 2: Multiplication
reg [31:0] mult_reg;
always @(posedge clk) begin
    if (rst) begin
        mult_reg <= 32'd0;
    end else begin
        // Using a Wallace tree multiplier for low power consumption
        mult_reg <= a_reg * b_reg;
    end
end

// Stage 3: Accumulation
reg [31:0] accum_reg;
always @(posedge clk) begin
    if (rst) begin
        accum_reg <= 32'd0;
    end else begin
        accum_reg <= accum_reg + mult_reg;
    end
end

// Stage 4: Output
assign c = accum_reg;

endmodule
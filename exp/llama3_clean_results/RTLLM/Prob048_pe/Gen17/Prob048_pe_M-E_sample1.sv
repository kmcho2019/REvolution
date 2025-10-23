module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

// Stage 1: Multiplication
reg [63:0] mult_result;
always @(posedge clk or posedge rst) begin
    if (rst) begin
        mult_result <= 64'd0;
    end else begin
        mult_result <= a * b;
    end
end

// Stage 2: Accumulation
reg [63:0] accum_result;
always @(posedge clk or posedge rst) begin
    if (rst) begin
        accum_result <= 64'd0;
    end else begin
        accum_result <= accum_result + mult_result;
    end
end

// Stage 3: Registering the Result
reg [31:0] c_reg;
always @(posedge clk or posedge rst) begin
    if (rst) begin
        c_reg <= 32'd0;
    end else begin
        c_reg <= accum_result[31:0];  // Only take the lower 32 bits
    end
end

assign c = c_reg;

endmodule
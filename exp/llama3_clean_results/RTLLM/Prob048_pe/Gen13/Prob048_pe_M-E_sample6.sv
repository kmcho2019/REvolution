module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

// Stage 1: Operand Fetch
reg [31:0] a_reg, b_reg;
always @(posedge clk or posedge rst) begin
    if (rst) begin
        a_reg <= 32'd0;
        b_reg <= 32'd0;
    end else begin
        a_reg <= a;
        b_reg <= b;
    end
end

// Stage 2: Multiplication
wire [31:0] mult;
assign mult = a_reg * b_reg;

// Stage 3: Accumulation
reg [31:0] c_reg;
always @(posedge clk or posedge rst) begin
    if (rst) begin
        c_reg <= 32'd0;
    end else begin
        c_reg <= c_reg + mult;
    end
end

// Stage 4: Result Stage
assign c = c_reg;

endmodule
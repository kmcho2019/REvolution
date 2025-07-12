module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

// Pipelined Multiplier
wire [31:0] mult1, mult2;
reg [31:0] mult_reg;

always @(posedge clk) begin
    if (rst) begin
        mult_reg <= 32'd0;
    end else begin
        mult1 <= a * b;
        mult_reg <= mult1;
    end
end

// Carry-Save Accumulation
reg [31:0] c_reg;
reg [31:0] c_reg_next;

always @(posedge clk) begin
    if (rst) begin
        c_reg <= 32'd0;
    end else begin
        c_reg_next = c_reg + mult_reg;
        c_reg <= c_reg_next;
    end
end

// Output Assignment
assign c = c_reg;

endmodule
module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

reg [31:0] c_reg;  // Register to store the accumulated result
wire [31:0] mult_result;  // Wire to store the result of multiplication
reg clk_en;  // Clock enable signal for clock gating

// Combinational logic for multiplication using a pipelined multiplier
assign mult_result = a * b;

// Clock gating logic
always @(posedge clk) begin
    if (rst) begin
        clk_en <= 1'b0;
    end else begin
        clk_en <= 1'b1;
    end
end

// Sequential logic for accumulation with clock gating
always @(posedge clk) begin
    if (rst) begin
        c_reg <= 32'd0;
    end else if (clk_en) begin
        c_reg <= c_reg + mult_result;
    end
end

// Output assignment
assign c = c_reg;

endmodule
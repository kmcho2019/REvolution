module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

reg [31:0] c_reg;  // Register to store the accumulated result

assign c = c_reg;

// Pipelined accumulator
reg [31:0] pipe_reg;
always @(posedge clk) begin
    if (rst) begin
        pipe_reg <= 32'd0;
        c_reg <= 32'd0;
    end else begin
        pipe_reg <= a * b;
        c_reg <= c_reg + pipe_reg;
    end
end

// Alternative approach using array multiplication
// reg [31:0] mult_reg;
// always @(posedge clk) begin
//     if (rst) begin
//         mult_reg <= 32'd0;
//         c_reg <= 32'd0;
//     end else begin
//         mult_reg <= a * b;
//         c_reg <= c_reg + mult_reg;
//     end
// end

// Clock gating
// reg clk_enable;
// always @(posedge clk) begin
//     if (rst) begin
//         clk_enable <= 1'b0;
//     end else begin
//         clk_enable <= (a!= 32'd0) || (b!= 32'd0);
//     end
// end
// always @(posedge clk) begin
//     if (clk_enable) begin
//         c_reg <= c_reg + (a * b);
//     end
// end

endmodule
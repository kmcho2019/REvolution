module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

reg [31:0] c_reg;  // Register to store the accumulated result
wire [31:0] add_result;  // Wire to store the result of addition

// Combinational logic for multiplication and addition
assign add_result = c_reg + (a * b);

// Sequential logic for accumulation
always @(posedge clk or posedge rst) begin
    if (rst) begin
        c_reg <= 32'd0;
    end else begin
        c_reg <= add_result;
    end
end

// Output assignment
assign c = c_reg;

endmodule
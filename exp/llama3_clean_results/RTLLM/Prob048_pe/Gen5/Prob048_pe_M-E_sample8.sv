module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

reg [31:0] c_reg;  // Register to store the accumulated result
reg [31:0] pipeline_reg1, pipeline_reg2, pipeline_reg3;  // Pipeline registers

wire [31:0] mult_result1, mult_result2, mult_result3, mult_result4;  // Combinational signals for multiplication results

// Stage 1: Multiply lower 8 bits of a and b
assign mult_result1 = (a[7:0] * b[7:0]);

// Stage 2: Multiply next 8 bits of a and b, and accumulate with previous result
assign mult_result2 = (a[15:8] * b[7:0]) + (pipeline_reg1 << 8);

// Stage 3: Multiply next 8 bits of a and b, and accumulate with previous result
assign mult_result3 = (a[23:16] * b[7:0]) + (pipeline_reg2 << 8);

// Stage 4: Multiply upper 8 bits of a and b, and accumulate with previous result
assign mult_result4 = (a[31:24] * b[7:0]) + (pipeline_reg3 << 8);

always @(posedge clk) begin
    if (rst) begin
        c_reg <= 32'd0;
        pipeline_reg1 <= 32'd0;
        pipeline_reg2 <= 32'd0;
        pipeline_reg3 <= 32'd0;
    end else begin
        pipeline_reg1 <= mult_result1;
        pipeline_reg2 <= mult_result2;
        pipeline_reg3 <= mult_result3;
        c_reg <= mult_result4;
    end
end

assign c = c_reg;  // Assign output

endmodule
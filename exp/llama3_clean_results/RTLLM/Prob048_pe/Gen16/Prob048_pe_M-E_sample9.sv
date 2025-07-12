module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

// Systolic Array Multiplier
wire [31:0] mult_result;

// Define the systolic array multiplier
systolic_multiplier sm(
    .a(a),
    .b(b),
    .result(mult_result)
);

// Pipelined Accumulation Stage 1
reg [31:0] pipe_reg1;

always @(posedge clk) begin
    if (rst) begin
        pipe_reg1 <= 32'd0;
    end else begin
        pipe_reg1 <= mult_result;
    end
end

// Pipelined Accumulation Stage 2
reg [31:0] pipe_reg2;

always @(posedge clk) begin
    if (rst) begin
        pipe_reg2 <= 32'd0;
    end else begin
        pipe_reg2 <= pipe_reg1;
    end
end

// Pipelined Accumulation Stage 3 (Final Stage)
reg [31:0] c_reg;

always @(posedge clk) begin
    if (rst) begin
        c_reg <= 32'd0;
    end else begin
        c_reg <= c_reg + pipe_reg2;
    end
end

// Output Assignment
assign c = c_reg;

endmodule

// Define the systolic multiplier module
module systolic_multiplier(
    input [31:0] a,
    input [31:0] b,
    output [31:0] result
);

// Define the systolic array structure
reg [15:0] mult_array [3:0];

// Perform multiplication operations in the systolic array
always @(posedge clk) begin
    mult_array[0] <= a[7:0] * b[7:0];
    mult_array[1] <= a[15:8] * b[15:8];
    mult_array[2] <= a[23:16] * b[23:16];
    mult_array[3] <= a[31:24] * b[31:24];
end

// Combine the results of the systolic array
assign result = mult_array[0] + (mult_array[1] << 8) + (mult_array[2] << 16) + (mult_array[3] << 24);

endmodule
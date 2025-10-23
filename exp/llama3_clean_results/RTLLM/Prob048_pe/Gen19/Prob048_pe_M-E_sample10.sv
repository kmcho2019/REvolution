module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

// Stage 1: Operand Fetch and Alignment
reg [31:0] a_reg, b_reg;
always @(posedge clk) begin
    if (rst) begin
        a_reg <= 32'd0;
        b_reg <= 32'd0;
    end else begin
        a_reg <= a;
        b_reg <= b;
    end
end

// Stage 2: Parallel Multiplication
wire [63:0] mult_result;
assign mult_result = a_reg * b_reg;

// Stage 3: Accumulation
reg [31:0] acc_reg;
always @(posedge clk) begin
    if (rst) begin
        acc_reg <= 32'd0;
    end else begin
        acc_reg <= acc_reg + mult_result[31:0];
    end
end

// Stage 4: Result Storage
reg [31:0] result_reg;
always @(posedge clk) begin
    if (rst) begin
        result_reg <= 32'd0;
    end else begin
        result_reg <= acc_reg;
    end
end

// Output Assignment
assign c = result_reg;

endmodule
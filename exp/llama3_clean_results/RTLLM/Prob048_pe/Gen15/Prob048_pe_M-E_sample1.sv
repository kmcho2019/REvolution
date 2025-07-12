module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

// Pipeline Stage 1: Input Processing
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

// Pipeline Stage 2: Partial Product Generation
wire [31:0] partial_product;
assign partial_product = a_reg * b_reg[7:0];

// Pipeline Stage 3: Pipelined Accumulation
reg [31:0] acc_reg;
always @(posedge clk) begin
    if (rst) begin
        acc_reg <= 32'd0;
    end else begin
        acc_reg <= acc_reg + partial_product;
    end
end

// Pipeline Stage 4: Final Result
assign c = acc_reg;

endmodule
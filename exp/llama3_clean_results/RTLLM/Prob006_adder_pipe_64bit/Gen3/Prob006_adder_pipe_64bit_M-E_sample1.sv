module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

// Split 64-bit operands into 16-bit chunks
reg [15:0] chunk_a0, chunk_a1, chunk_a2, chunk_a3;
reg [15:0] chunk_b0, chunk_b1, chunk_b2, chunk_b3;

// Internal carry signals
reg        carry_0, carry_1, carry_2;

// Internal results
reg [15:0] result_0, result_1, result_2, result_3;

// Registers for pipeline stages
reg [15:0] reg_result_0, reg_result_1, reg_result_2, reg_result_3;
reg        reg_carry_0, reg_carry_1, reg_carry_2;
reg        reg_o_en;

// Assign input chunks
always @ (*) begin
    chunk_a0 = adda[15:0];
    chunk_a1 = adda[31:16];
    chunk_a2 = adda[47:32];
    chunk_a3 = adda[63:48];

    chunk_b0 = addb[15:0];
    chunk_b1 = addb[31:16];
    chunk_b2 = addb[47:32];
    chunk_b3 = addb[63:48];
end

// Calculate internal results
always @ (*) begin
    {carry_0, result_0} = chunk_a0 + chunk_b0;
    {carry_1, result_1} = chunk_a1 + chunk_b1 + carry_0;
    {carry_2, result_2} = chunk_a2 + chunk_b2 + carry_1;
    {result_3[15], result_3} = chunk_a3 + chunk_b3 + carry_2;
end

// Pipeline stages
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_result_0 <= 16'd0;
        reg_result_1 <= 16'd0;
        reg_result_2 <= 16'd0;
        reg_result_3 <= 16'd0;
        reg_carry_0 <= 1'b0;
        reg_carry_1 <= 1'b0;
        reg_carry_2 <= 1'b0;
        reg_o_en <= 1'b0;
    end else if (i_en) begin
        reg_result_0 <= result_0;
        reg_result_1 <= result_1;
        reg_result_2 <= result_2;
        reg_result_3 <= result_3;
        reg_carry_0 <= carry_0;
        reg_carry_1 <= carry_1;
        reg_carry_2 <= carry_2;
        reg_o_en <= 1'b1;
    end else begin
        reg_o_en <= 1'b0;
    end
end

// Assign output result
assign result = {1'b0, reg_result_3, reg_result_2, reg_result_1, reg_result_0};
assign o_en = reg_o_en;

endmodule
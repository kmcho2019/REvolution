module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline registers
reg [63:0] a_reg, b_reg;
reg [7:0] sum0, sum1, sum2, sum3, sum4, sum5, sum6, sum7;
reg carry0, carry1, carry2, carry3, carry4, carry5, carry6, carry7;
reg [7:0] en_pipe;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        a_reg <= 64'b0;
        b_reg <= 64'b0;
        {sum0, sum1, sum2, sum3, sum4, sum5, sum6, sum7} <= {8{8'b0}};
        {carry0, carry1, carry2, carry3, carry4, carry5, carry6, carry7} <= 8'b0;
        en_pipe <= 8'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Stage 0: Input and first segment
        a_reg <= adda;
        b_reg <= addb;
        {carry0, sum0} <= adda[7:0] + addb[7:0];
        en_pipe[0] <= i_en;

        // Subsequent stages
        {carry1, sum1} <= a_reg[15:8] + b_reg[15:8] + carry0;
        {carry2, sum2} <= a_reg[23:16] + b_reg[23:16] + carry1;
        {carry3, sum3} <= a_reg[31:24] + b_reg[31:24] + carry2;
        {carry4, sum4} <= a_reg[39:32] + b_reg[39:32] + carry3;
        {carry5, sum5} <= a_reg[47:40] + b_reg[47:40] + carry4;
        {carry6, sum6} <= a_reg[55:48] + b_reg[55:48] + carry5;
        {carry7, sum7} <= a_reg[63:56] + b_reg[63:56] + carry6;

        // Pipeline enable signal
        en_pipe[7:1] <= en_pipe[6:0];

        // Final output
        result <= {carry7, sum7, sum6, sum5, sum4, sum3, sum2, sum1, sum0};
        o_en <= en_pipe[7];
    end
end

endmodule
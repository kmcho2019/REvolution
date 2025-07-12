module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 8
) (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [DATA_WIDTH-1:0] adda,
    input wire [DATA_WIDTH-1:0] addb,
    output reg [DATA_WIDTH:0] result,
    output reg o_en
);

// Pipeline registers
reg [DATA_WIDTH-1:0] a_reg, b_reg;
reg [STG_WIDTH-1:0] sum0, sum1, sum2, sum3, sum4, sum5, sum6, sum7;
reg carry0, carry1, carry2, carry3, carry4, carry5, carry6, carry7;
reg [7:0] en_pipe;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        a_reg <= {DATA_WIDTH{1'b0}};
        b_reg <= {DATA_WIDTH{1'b0}};
        {sum0, sum1, sum2, sum3, sum4, sum5, sum6, sum7} <= {8{8'b0}};
        {carry0, carry1, carry2, carry3, carry4, carry5, carry6, carry7} <= 8'b0;
        en_pipe <= 8'b0;
        result <= {(DATA_WIDTH+1){1'b0}};
        o_en <= 1'b0;
    end else begin
        // Stage 0: Input and first segment
        a_reg <= adda;
        b_reg <= addb;
        {carry0, sum0} <= adda[STG_WIDTH-1:0] + addb[STG_WIDTH-1:0];
        en_pipe[0] <= i_en;

        // Subsequent stages
        {carry1, sum1} <= a_reg[2*STG_WIDTH-1:STG_WIDTH] + b_reg[2*STG_WIDTH-1:STG_WIDTH] + carry0;
        {carry2, sum2} <= a_reg[3*STG_WIDTH-1:2*STG_WIDTH] + b_reg[3*STG_WIDTH-1:2*STG_WIDTH] + carry1;
        {carry3, sum3} <= a_reg[4*STG_WIDTH-1:3*STG_WIDTH] + b_reg[4*STG_WIDTH-1:3*STG_WIDTH] + carry2;
        {carry4, sum4} <= a_reg[5*STG_WIDTH-1:4*STG_WIDTH] + b_reg[5*STG_WIDTH-1:4*STG_WIDTH] + carry3;
        {carry5, sum5} <= a_reg[6*STG_WIDTH-1:5*STG_WIDTH] + b_reg[6*STG_WIDTH-1:5*STG_WIDTH] + carry4;
        {carry6, sum6} <= a_reg[7*STG_WIDTH-1:6*STG_WIDTH] + b_reg[7*STG_WIDTH-1:6*STG_WIDTH] + carry5;
        {carry7, sum7} <= a_reg[8*STG_WIDTH-1:7*STG_WIDTH] + b_reg[8*STG_WIDTH-1:7*STG_WIDTH] + carry6;

        // Pipeline enable signal
        en_pipe[7:1] <= en_pipe[6:0];

        // Final output
        result <= {carry7, sum7, sum6, sum5, sum4, sum3, sum2, sum1, sum0};
        o_en <= en_pipe[7];
    end
end

endmodule
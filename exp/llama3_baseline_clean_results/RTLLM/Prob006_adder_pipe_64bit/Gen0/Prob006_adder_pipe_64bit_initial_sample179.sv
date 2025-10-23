module adder_pipe_64bit(
    input         clk,
    input         rst_n,
    input         i_en,
    input  [63:0] adda,
    input  [63:0] addb,
    output [64:0] result,
    output        o_en
);

reg [63:0] adda_reg;
reg [63:0] addb_reg;
reg [63:0] sum_reg [3:0]; // 4 pipeline stages
reg        carry_reg [3:0];
reg        i_en_reg [3:0];
reg        o_en_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_reg <= 64'd0;
        addb_reg <= 64'd0;
        sum_reg[0] <= 64'd0;
        sum_reg[1] <= 64'd0;
        sum_reg[2] <= 64'd0;
        sum_reg[3] <= 64'd0;
        carry_reg[0] <= 1'b0;
        carry_reg[1] <= 1'b0;
        carry_reg[2] <= 1'b0;
        carry_reg[3] <= 1'b0;
        i_en_reg[0] <= 1'b0;
        i_en_reg[1] <= 1'b0;
        i_en_reg[2] <= 1'b0;
        i_en_reg[3] <= 1'b0;
        o_en_reg <= 1'b0;
    end else begin
        // Pipeline stage 1: Input registers
        if (i_en) begin
            adda_reg <= adda;
            addb_reg <= addb;
            i_en_reg[0] <= 1'b1;
        end else begin
            i_en_reg[0] <= 1'b0;
        end

        // Pipeline stage 2: Calculate sum and carry
        sum_reg[0] <= adda_reg + addb_reg;
        carry_reg[0] <= (adda_reg[63] + addb_reg[63]) > 63? 1'b1 : 1'b0;
        i_en_reg[1] <= i_en_reg[0];

        // Pipeline stage 3: Propagate carry
        sum_reg[1] <= sum_reg[0];
        carry_reg[1] <= carry_reg[0];
        i_en_reg[2] <= i_en_reg[1];

        // Pipeline stage 4: Output registers
        sum_reg[2] <= sum_reg[1];
        carry_reg[2] <= carry_reg[1];
        i_en_reg[3] <= i_en_reg[2];

        // Output stage
        sum_reg[3] <= sum_reg[2];
        carry_reg[3] <= carry_reg[2];
        o_en_reg <= i_en_reg[3];
    end
end

always @(*) begin
    result = {carry_reg[3], sum_reg[3]};
end

assign o_en = o_en_reg;

endmodule
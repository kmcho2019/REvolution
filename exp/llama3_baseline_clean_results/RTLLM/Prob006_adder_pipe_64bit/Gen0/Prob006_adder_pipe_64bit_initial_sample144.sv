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
reg [63:0] sum_reg [4:0];
reg [63:0] carry_reg [4:0];
reg         i_en_reg;
reg         o_en_reg;
reg [2:0]   counter;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_reg <= 64'd0;
        addb_reg <= 64'd0;
        sum_reg[0] <= 64'd0;
        carry_reg[0] <= 64'd0;
        sum_reg[1] <= 64'd0;
        carry_reg[1] <= 64'd0;
        sum_reg[2] <= 64'd0;
        carry_reg[2] <= 64'd0;
        sum_reg[3] <= 64'd0;
        carry_reg[3] <= 64'd0;
        sum_reg[4] <= 64'd0;
        i_en_reg <= 1'd0;
        o_en_reg <= 1'd0;
        counter <= 3'd0;
    end else if (i_en) begin
        adda_reg <= adda;
        addb_reg <= addb;
        i_en_reg <= i_en;
        counter <= 3'd1;
    end else if (counter == 3'd4) begin
        o_en_reg <= 1'd1;
    end else begin
        counter <= counter + 1'd1;
    end
end

always @(posedge clk) begin
    if (i_en_reg) begin
        sum_reg[0] <= adda_reg + addb_reg;
        carry_reg[0] <= (adda_reg[63] + addb_reg[63]) > 1'd1;
    end
    if (counter == 3'd1) begin
        sum_reg[1] <= sum_reg[0];
        carry_reg[1] <= carry_reg[0];
    end
    if (counter == 3'd2) begin
        sum_reg[2] <= sum_reg[1];
        carry_reg[2] <= carry_reg[1];
    end
    if (counter == 3'd3) begin
        sum_reg[3] <= sum_reg[2];
        carry_reg[3] <= carry_reg[2];
    end
    if (counter == 3'd4) begin
        sum_reg[4] <= sum_reg[3];
        o_en_reg <= 1'd1;
    end
end

always @(posedge clk) begin
    if (o_en_reg) begin
        result <= {carry_reg[3], sum_reg[4]};
    end
end

assign o_en = o_en_reg;

endmodule
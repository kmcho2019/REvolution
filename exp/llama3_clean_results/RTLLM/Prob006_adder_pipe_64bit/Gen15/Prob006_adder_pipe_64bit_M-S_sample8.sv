module rca_4bit(
    input   [3:0]  a,
    input   [3:0]  b,
    input           cin,
    output  [3:0]  sum,
    output          cout
);
    assign sum = a + b + cin;
    assign cout = (a[3] & b[3]) | (a[3] & cin) | (b[3] & cin);
endmodule

module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);
    reg     [63:0]  adda_reg;
    reg     [63:0]  addb_reg;
    reg     [3:0]   sum_stage [15:0];
    reg             cout_stage [15:0];
    reg             i_en_reg;
    reg             o_en_reg;

    always @ (posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            i_en_reg <= 1'b0;
            o_en_reg <= 1'b0;
        end else begin
            i_en_reg <= i_en;
            o_en_reg <= (i_en_reg && (i_en == 1'b0));
        end
    end

    always @ (posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            adda_reg <= 64'd0;
            addb_reg <= 64'd0;
        end else if (i_en) begin
            adda_reg <= adda;
            addb_reg <= addb;
        end
    end

    // Pipeline stages
    wire [3:0] cin [15:0];
    assign cin[0] = 1'b0;
    for (genvar i = 1; i < 16; i++) begin
        assign cin[i] = cout_stage[i - 1];
    end

    for (genvar i = 0; i < 16; i++) begin
        rca_4bit u_rca(
            .a    (adda_reg[4*i +: 4]),
            .b    (addb_reg[4*i +: 4]),
            .cin  (cin[i]),
            .sum  (sum_stage[i]),
            .cout (cout_stage[i])
        );
    end

    // Assign result
    assign result = {1'b0, sum_stage[15], sum_stage[14], sum_stage[13], sum_stage[12], sum_stage[11], sum_stage[10], sum_stage[9], sum_stage[8], sum_stage[7], sum_stage[6], sum_stage[5], sum_stage[4], sum_stage[3], sum_stage[2], sum_stage[1], sum_stage[0]};

    // Assign output enable signal
    assign o_en = o_en_reg;
endmodule
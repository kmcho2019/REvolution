module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input cin,
    output [15:0] sum,
    output cout
);

    assign sum = a + b + cin;
    assign cout = (a[15] & b[15]) | (a[15] & cin) | (b[15] & cin);

endmodule

module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output reg o_en
);

    reg [15:0] sum_reg [3:0];
    reg cout_reg [3:0];
    reg [3:0] stage;
    reg i_en_reg;
    reg [15:0] adda_reg [3:0];
    reg [15:0] addb_reg [3:0];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            o_en <= 1'b0;
            stage <= 4'd0;
            i_en_reg <= 1'b0;
            sum_reg <= '{default: 16'd0};
            cout_reg <= '{default: 1'b0};
            adda_reg <= '{default: 16'd0};
            addb_reg <= '{default: 16'd0};
        end else begin
            if (i_en) begin
                adda_reg[0] <= adda[15:0];
                addb_reg[0] <= addb[15:0];
                adda_reg[1] <= adda[31:16];
                addb_reg[1] <= addb[31:16];
                adda_reg[2] <= adda[47:32];
                addb_reg[2] <= addb[47:32];
                adda_reg[3] <= adda[63:48];
                addb_reg[3] <= addb[63:48];
            end
            if (stage == 4'd0 && i_en) begin
                sum_reg[0] <= adda_reg[0] + addb_reg[0];
                cout_reg[0] <= (adda_reg[0][15] & addb_reg[0][15]) | (adda_reg[0][15] & 1'b0) | (addb_reg[0][15] & 1'b0);
                stage <= stage + 1;
            end else if (stage == 4'd1) begin
                sum_reg[1] <= adda_reg[1] + addb_reg[1] + cout_reg[0];
                cout_reg[1] <= (adda_reg[1][15] & addb_reg[1][15]) | (adda_reg[1][15] & cout_reg[0]) | (addb_reg[1][15] & cout_reg[0]);
                stage <= stage + 1;
            end else if (stage == 4'd2) begin
                sum_reg[2] <= adda_reg[2] + addb_reg[2] + cout_reg[1];
                cout_reg[2] <= (adda_reg[2][15] & addb_reg[2][15]) | (adda_reg[2][15] & cout_reg[1]) | (addb_reg[2][15] & cout_reg[1]);
                stage <= stage + 1;
            end else if (stage == 4'd3) begin
                sum_reg[3] <= adda_reg[3] + addb_reg[3] + cout_reg[2];
                cout_reg[3] <= (adda_reg[3][15] & addb_reg[3][15]) | (adda_reg[3][15] & cout_reg[2]) | (addb_reg[3][15] & cout_reg[2]);
                o_en <= 1'b1;
                stage <= 4'd0;
            end else begin
                o_en <= 1'b0;
            end
        end
    end

    assign result = {cout_reg[3], sum_reg[3], sum_reg[2], sum_reg[1], sum_reg[0]};

endmodule
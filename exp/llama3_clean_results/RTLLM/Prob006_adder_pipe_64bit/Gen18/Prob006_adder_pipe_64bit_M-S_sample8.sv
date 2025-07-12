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

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            o_en <= 1'b0;
            stage <= 4'd0;
            i_en_reg <= 1'b0;
            sum_reg <= '{default: 16'd0};
            cout_reg <= '{default: 1'b0};
        end else begin
            i_en_reg <= i_en;
            if (i_en_reg) begin
                o_en <= 1'b1;
                stage <= stage + 1;
                if (stage == 4'd3) begin
                    stage <= 4'd0;
                end
            end else begin
                o_en <= 1'b0;
            end
            sum_reg[0] <= adda[15:0] + addb[15:0];
            cout_reg[0] <= (adda[15] & addb[15]) | (adda[15] & 1'b0) | (addb[15] & 1'b0);
            for (int i = 1; i < 4; i++) begin
                sum_reg[i] <= adda[(i+1)*16-1:i*16] + addb[(i+1)*16-1:i*16] + cout_reg[i-1];
                cout_reg[i] <= (adda[(i+1)*16-1] & addb[(i+1)*16-1]) | (adda[(i+1)*16-1] & cout_reg[i-1]) | (addb[(i+1)*16-1] & cout_reg[i-1]);
            end
        end
    end

    assign result = {cout_reg[3], sum_reg[3], sum_reg[2], sum_reg[1], sum_reg[0]};

endmodule
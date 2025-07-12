module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output reg o_en
);

    reg [63:0] sum;
    reg [63:0] adda_reg;
    reg [63:0] addb_reg;
    reg i_en_reg;
    reg i_en_reg2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            adda_reg <= 64'd0;
            addb_reg <= 64'd0;
            i_en_reg <= 1'b0;
            i_en_reg2 <= 1'b0;
            o_en <= 1'b0;
        end else begin
            adda_reg <= adda;
            addb_reg <= addb;
            i_en_reg <= i_en;
            i_en_reg2 <= i_en_reg;
            if (i_en_reg2) begin
                sum <= adda_reg + addb_reg;
                o_en <= 1'b1;
            end else begin
                o_en <= 1'b0;
            end
        end
    end

    assign result = {1'b0, sum};

endmodule

module testbench;
    reg clk;
    reg rst_n;
    reg i_en;
    reg [63:0] adda;
    reg [63:0] addb;
    wire [64:0] result;
    wire o_en;

    adder_pipe_64bit uut(
        .clk(clk),
        .rst_n(rst_n),
        .i_en(i_en),
        .adda(adda),
        .addb(addb),
        .result(result),
        .o_en(o_en)
    );

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        i_en = 1'b0;
        adda = 64'd0;
        addb = 64'd0;
        #100;
        rst_n = 1'b1;
        #100;
        i_en = 1'b1;
        adda = 64'd100;
        addb = 64'd200;
        #100;
        i_en = 1'b0;
        #100;
        $finish;
    end

    always #50 clk = ~clk;

endmodule
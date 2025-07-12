module adder_4bit(
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);

    assign sum = a + b + cin;
    assign cout = (a[3] & b[3]) | (a[3] & cin) | (b[3] & cin);

endmodule

module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input cin,
    output [15:0] sum,
    output cout
);

    wire [3:0] sum0, sum1, sum2, sum3;
    wire cout0, cout1, cout2;

    adder_4bit u0(
       .a(a[3:0]),
       .b(b[3:0]),
       .cin(cin),
       .sum(sum0),
       .cout(cout0)
    );

    adder_4bit u1(
       .a(a[7:4]),
       .b(b[7:4]),
       .cin(cout0),
       .sum(sum1),
       .cout(cout1)
    );

    adder_4bit u2(
       .a(a[11:8]),
       .b(b[11:8]),
       .cin(cout1),
       .sum(sum2),
       .cout(cout2)
    );

    adder_4bit u3(
       .a(a[15:12]),
       .b(b[15:12]),
       .cin(cout2),
       .sum(sum3),
       .cout(cout)
    );

    assign sum = {sum3, sum2, sum1, sum0};

endmodule

module adder_64bit(
    input [63:0] a,
    input [63:0] b,
    input cin,
    output [63:0] sum,
    output cout
);

    wire [15:0] sum0, sum1, sum2, sum3;
    wire cout0, cout1, cout2;

    adder_16bit u0(
       .a(a[15:0]),
       .b(b[15:0]),
       .cin(cin),
       .sum(sum0),
       .cout(cout0)
    );

    adder_16bit u1(
       .a(a[31:16]),
       .b(b[31:16]),
       .cin(cout0),
       .sum(sum1),
       .cout(cout1)
    );

    adder_16bit u2(
       .a(a[47:32]),
       .b(b[47:32]),
       .cin(cout1),
       .sum(sum2),
       .cout(cout2)
    );

    adder_16bit u3(
       .a(a[63:48]),
       .b(b[63:48]),
       .cin(cout2),
       .sum(sum3),
       .cout(cout)
    );

    assign sum = {sum3, sum2, sum1, sum0};

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

    reg [63:0] sum_reg;
    reg cout_reg;
    reg [63:0] adda_reg;
    reg [63:0] addb_reg;
    reg i_en_reg;
    reg [1:0] stage;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            o_en <= 1'b0;
            stage <= 2'd0;
            i_en_reg <= 1'b0;
            sum_reg <= 64'd0;
            cout_reg <= 1'b0;
            adda_reg <= 64'd0;
            addb_reg <= 64'd0;
        end else begin
            if (i_en) begin
                adda_reg <= adda;
                addb_reg <= addb;
                i_en_reg <= i_en;
                stage <= 2'd1;
            end else if (stage == 2'd1) begin
                adder_64bit u0(
                   .a(adda_reg),
                   .b(addb_reg),
                   .cin(1'b0),
                   .sum(sum_reg[63:0]),
                   .cout(cout_reg)
                );
                stage <= 2'd2;
            end else if (stage == 2'd2) begin
                o_en <= 1'b1;
                stage <= 2'd0;
            end else begin
                o_en <= 1'b0;
            end
        end
    end

    assign result = {cout_reg, sum_reg};

endmodule
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

module pipeline_stage(
    input clk,
    input rst_n,
    input [15:0] sum_in,
    input cin_in,
    output [15:0] sum_out,
    output cout_out
);

    reg [15:0] sum_reg;
    reg cout_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_reg <= 16'd0;
            cout_reg <= 1'b0;
        end else begin
            sum_reg <= sum_in;
            cout_reg <= cin_in;
        end
    end

    assign sum_out = sum_reg;
    assign cout_out = cout_reg;

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

    reg [3:0] stage;
    wire [15:0] sum [3:0];
    wire cout [3:0];
    reg [15:0] sum_reg [3:0];
    reg cout_reg [3:0];

    genvar i;
    generate
        for (i = 0; i < 4; i++) begin
            adder_16bit u1(
               .a(adda[(i+1)*16-1:i*16]),
               .b(addb[(i+1)*16-1:i*16]),
               .cin(i == 0? 1'b0 : cout[i-1]),
               .sum(sum[i]),
               .cout(cout[i])
            );

            pipeline_stage u2(
               .clk(clk),
               .rst_n(rst_n),
               .sum_in(sum[i]),
               .cin_in(cout[i]),
               .sum_out(sum_reg[i]),
               .cout_out(cout_reg[i])
            );
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            o_en <= 1'b0;
            stage <= 4'd0;
        end else begin
            if (i_en) begin
                o_en <= 1'b1;
                stage <= stage + 1;
                if (stage == 4'd3) begin
                    stage <= 4'd0;
                end
            end else begin
                o_en <= 1'b0;
            end
        end
    end

    assign result = {cout_reg[3], sum_reg[3], sum_reg[2], sum_reg[1], sum_reg[0]};

endmodule
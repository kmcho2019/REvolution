module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule

module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input cin,
    output [15:0] sum,
    output cout
);

    wire [15:0] sum_w;
    wire [15:0] cout_w;
    wire cin_w;

    full_adder fa0(
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .sum(sum_w[0]),
        .cout(cout_w[0])
    );

    generate
        for (genvar i = 1; i < 16; i++) begin
            full_adder fa(
                .a(a[i]),
                .b(b[i]),
                .cin(cout_w[i-1]),
                .sum(sum_w[i]),
                .cout(cout_w[i])
            );
        end
    endgenerate

    assign sum = sum_w;
    assign cout = cout_w[15];

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

    reg [15:0] sum_reg [3:0];
    reg cout_reg [3:0];
    reg [1:0] stage;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_reg[0] <= 16'd0;
            sum_reg[1] <= 16'd0;
            sum_reg[2] <= 16'd0;
            sum_reg[3] <= 16'd0;
            cout_reg[0] <= 1'b0;
            cout_reg[1] <= 1'b0;
            cout_reg[2] <= 1'b0;
            cout_reg[3] <= 1'b0;
            stage <= 2'd0;
            o_en <= 1'b0;
        end else if (i_en) begin
            case (stage)
                2'd0: begin
                    adder_16bit u1(
                        .a(adda[15:0]),
                        .b(addb[15:0]),
                        .cin(1'b0),
                        .sum(sum_reg[0]),
                        .cout(cout_reg[0])
                    );
                    stage <= 2'd1;
                end
                2'd1: begin
                    adder_16bit u2(
                        .a(adda[31:16]),
                        .b(addb[31:16]),
                        .cin(cout_reg[0]),
                        .sum(sum_reg[1]),
                        .cout(cout_reg[1])
                    );
                    stage <= 2'd2;
                end
                2'd2: begin
                    adder_16bit u3(
                        .a(adda[47:32]),
                        .b(addb[47:32]),
                        .cin(cout_reg[1]),
                        .sum(sum_reg[2]),
                        .cout(cout_reg[2])
                    );
                    stage <= 2'd3;
                end
                2'd3: begin
                    adder_16bit u4(
                        .a(adda[63:48]),
                        .b(addb[63:48]),
                        .cin(cout_reg[2]),
                        .sum(sum_reg[3]),
                        .cout(cout_reg[3])
                    );
                    o_en <= 1'b1;
                    stage <= 2'd0;
                end
            endcase
        end else begin
            o_en <= 1'b0;
        end
    end

    assign result = {cout_reg[3], sum_reg[3], sum_reg[2], sum_reg[1], sum_reg[0]};

endmodule
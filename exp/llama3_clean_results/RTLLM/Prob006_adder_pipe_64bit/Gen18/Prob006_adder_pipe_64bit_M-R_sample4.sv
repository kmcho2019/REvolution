// Module for input registration stage
module reg_stage #(
    parameter DATA_WIDTH = 64
)(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [DATA_WIDTH-1:0]  adda,
    input   [DATA_WIDTH-1:0]  addb,
    output  [DATA_WIDTH-1:0]  adda_reg,
    output  [DATA_WIDTH-1:0]  addb_reg,
    output          i_en_reg
);
    reg [DATA_WIDTH-1:0] adda_reg;
    reg [DATA_WIDTH-1:0] addb_reg;
    reg i_en_reg;

    always @ (posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            adda_reg <= {DATA_WIDTH{1'b0}};
            addb_reg <= {DATA_WIDTH{1'b0}};
            i_en_reg <= 1'b0;
        end else if (i_en) begin
            adda_reg <= adda;
            addb_reg <= addb;
            i_en_reg <= 1'b1;
        end
    end
endmodule

// Module for sum calculation stage
module sum_stage #(
    parameter DATA_WIDTH = 64
)(
    input   [DATA_WIDTH-1:0]  adda,
    input   [DATA_WIDTH-1:0]  addb,
    output  [DATA_WIDTH:0]  sum
);
    assign sum = adda + addb;
endmodule

// Module for output management stage
module out_stage #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 3
)(
    input           clk,
    input           rst_n,
    input           i_en_reg,
    input   [DATA_WIDTH:0]  sum,
    output  [DATA_WIDTH:0]  result,
    output          o_en
);
    reg [DATA_WIDTH:0] result;
    reg [STG_WIDTH-1:0] i_en_pipe;
    reg o_en;

    always @ (posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            result <= {DATA_WIDTH+1{1'b0}};
            i_en_pipe <= {STG_WIDTH{1'b0}};
            o_en <= 1'b0;
        end else begin
            i_en_pipe <= {i_en_pipe[STG_WIDTH-2:0], i_en_reg};
            result <= sum;
            if (i_en_pipe[STG_WIDTH-1]) begin
                o_en <= 1'b1;
            end else begin
                o_en <= 1'b0;
            end
        end
    end
endmodule

// Top-level module
module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 3
)(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [DATA_WIDTH-1:0]  adda,
    input   [DATA_WIDTH-1:0]  addb,
    output  [DATA_WIDTH:0]  result,
    output          o_en
);
    wire [DATA_WIDTH-1:0] adda_reg;
    wire [DATA_WIDTH-1:0] addb_reg;
    wire i_en_reg;
    wire [DATA_WIDTH:0] sum;

    reg_stage #(
       .DATA_WIDTH(DATA_WIDTH)
    ) u_reg_stage (
       .clk(clk),
       .rst_n(rst_n),
       .i_en(i_en),
       .adda(adda),
       .addb(addb),
       .adda_reg(adda_reg),
       .addb_reg(addb_reg),
       .i_en_reg(i_en_reg)
    );

    sum_stage #(
       .DATA_WIDTH(DATA_WIDTH)
    ) u_sum_stage (
       .adda(adda_reg),
       .addb(addb_reg),
       .sum(sum)
    );

    out_stage #(
       .DATA_WIDTH(DATA_WIDTH),
       .STG_WIDTH(STG_WIDTH)
    ) u_out_stage (
       .clk(clk),
       .rst_n(rst_n),
       .i_en_reg(i_en_reg),
       .sum(sum),
       .result(result),
       .o_en(o_en)
    );
endmodule

// Example testbench to verify the module's functionality
module tb_adder_pipe_64bit;
    reg clk;
    reg rst_n;
    reg i_en;
    reg [63:0] adda;
    reg [63:0] addb;
    wire [64:0] result;
    reg o_en;

    adder_pipe_64bit #(
       .DATA_WIDTH(64),
       .STG_WIDTH(3)
    ) u_pip_add64(
      .clk(clk),
      .rst_n(rst_n),
      .i_en(i_en),
      .adda(adda),
      .addb(addb),
      .result(result),
      .o_en(o_en)
    );

    initial begin
        clk = 0;
        rst_n = 1'b0;
        i_en = 1'b0;
        adda = 64'd0;
        addb = 64'd0;
        #10;
        rst_n = 1'b1;
        #10;
        i_en = 1'b1;
        adda = 64'd10;
        addb = 64'd20;
        #20;
        $finish;
    end

    always #5 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end
endmodule
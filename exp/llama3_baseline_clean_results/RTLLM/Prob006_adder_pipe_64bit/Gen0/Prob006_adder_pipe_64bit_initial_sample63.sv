module full_adder(
    input   a,
    input   b,
    input   cin,
    output  sum,
    output  cout
);

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule

module adder_pipe_64bit(
    input               clk,
    input               rst_n,
    input               i_en,
    input   [63:0]      adda,
    input   [63:0]      addb,
    output  [64:0]      result,
    output              o_en
);

    reg [63:0]           reg_adda;
    reg [63:0]           reg_addb;
    reg                  reg_i_en;
    reg                  reg_i_en_pipe1;
    reg                  reg_i_en_pipe2;
    reg [64:0]           sum_pipe1;
    reg [64:0]           sum_pipe2;

    assign result = sum_pipe2;
    assign o_en = reg_i_en_pipe2;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            reg_adda <= 64'd0;
            reg_addb <= 64'd0;
            reg_i_en <= 1'b0;
            reg_i_en_pipe1 <= 1'b0;
            reg_i_en_pipe2 <= 1'b0;
            sum_pipe1 <= 65'd0;
            sum_pipe2 <= 65'd0;
        end else begin
            reg_adda <= adda;
            reg_addb <= addb;
            reg_i_en <= i_en;
            reg_i_en_pipe1 <= reg_i_en;
            reg_i_en_pipe2 <= reg_i_en_pipe1;
            if (reg_i_en) begin
                sum_pipe1 <= {1'b0, reg_adda} + {1'b0, reg_addb};
            end
            sum_pipe2 <= sum_pipe1;
        end
    end

endmodule
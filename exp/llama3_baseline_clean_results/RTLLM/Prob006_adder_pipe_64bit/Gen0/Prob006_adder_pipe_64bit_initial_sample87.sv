module adder_pipe_64bit(
    input             clk,
    input             rst_n,
    input             i_en,
    input  [63:0]     adda,
    input  [63:0]     addb,
    output reg [64:0]  result,
    output reg         o_en
);

reg [63:0] adda_pipe [3:0];
reg [63:0] addb_pipe [3:0];
reg [63:0] sum_pipe [3:0];
reg [3:0]  carry_pipe;
reg         i_en_pipe [3:0];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_pipe[0] <= 64'd0;
        addb_pipe[0] <= 64'd0;
        sum_pipe[0] <= 64'd0;
        carry_pipe <= 1'b0;
        i_en_pipe[0] <= 1'b0;
        adda_pipe[1] <= 64'd0;
        addb_pipe[1] <= 64'd0;
        sum_pipe[1] <= 64'd0;
        carry_pipe <= 1'b0;
        i_en_pipe[1] <= 1'b0;
        adda_pipe[2] <= 64'd0;
        addb_pipe[2] <= 64'd0;
        sum_pipe[2] <= 64'd0;
        carry_pipe <= 1'b0;
        i_en_pipe[2] <= 1'b0;
        adda_pipe[3] <= 64'd0;
        addb_pipe[3] <= 64'd0;
        sum_pipe[3] <= 64'd0;
        carry_pipe <= 1'b0;
        i_en_pipe[3] <= 1'b0;
        o_en <= 1'b0;
        result <= 65'd0;
    end else if (i_en) begin
        adda_pipe[0] <= adda;
        addb_pipe[0] <= addb;
        i_en_pipe[0] <= 1'b1;
        adda_pipe[1] <= adda_pipe[0];
        addb_pipe[1] <= addb_pipe[0];
        i_en_pipe[1] <= i_en_pipe[0];
        adda_pipe[2] <= adda_pipe[1];
        addb_pipe[2] <= addb_pipe[1];
        i_en_pipe[2] <= i_en_pipe[1];
        adda_pipe[3] <= adda_pipe[2];
        addb_pipe[3] <= addb_pipe[2];
        i_en_pipe[3] <= i_en_pipe[2];
    end else begin
        adda_pipe[0] <= 64'd0;
        addb_pipe[0] <= 64'd0;
        i_en_pipe[0] <= 1'b0;
        adda_pipe[1] <= adda_pipe[0];
        addb_pipe[1] <= addb_pipe[0];
        i_en_pipe[1] <= i_en_pipe[0];
        adda_pipe[2] <= adda_pipe[1];
        addb_pipe[2] <= addb_pipe[1];
        i_en_pipe[2] <= i_en_pipe[1];
        adda_pipe[3] <= adda_pipe[2];
        addb_pipe[3] <= addb_pipe[2];
        i_en_pipe[3] <= i_en_pipe[2];
    end
end

always @(*) begin
    sum_pipe[0] = adda_pipe[0] + addb_pipe[0];
    sum_pipe[1] = sum_pipe[0];
    sum_pipe[2] = sum_pipe[1];
    sum_pipe[3] = sum_pipe[2];
end

always @(posedge clk) begin
    if (i_en_pipe[3]) begin
        result <= {1'b0, sum_pipe[3]} + {64'd0, carry_pipe};
        o_en <= 1'b1;
    end else begin
        o_en <= 1'b0;
    end
end

endmodule
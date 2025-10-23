module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

reg [63:0] adda_pipe1, addb_pipe1;
reg [63:0] adda_pipe2, addb_pipe2;
reg [63:0] adda_pipe3, addb_pipe3;
reg [15:0] sum1, sum2, sum3, sum4;
reg [15:0] carry1, carry2, carry3;
reg i_en_pipe1, i_en_pipe2, i_en_pipe3;
reg [64:0] result_pipe;

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_pipe1 <= 64'd0;
        addb_pipe1 <= 64'd0;
        adda_pipe2 <= 64'd0;
        addb_pipe2 <= 64'd0;
        adda_pipe3 <= 64'd0;
        addb_pipe3 <= 64'd0;
        i_en_pipe1 <= 1'b0;
        i_en_pipe2 <= 1'b0;
        i_en_pipe3 <= 1'b0;
        result_pipe <= 65'd0;
    end else if (i_en) begin
        adda_pipe1 <= adda;
        addb_pipe1 <= addb;
        i_en_pipe1 <= 1'b1;
    end else begin
        adda_pipe1 <= adda_pipe1;
        addb_pipe1 <= addb_pipe1;
        i_en_pipe1 <= i_en_pipe1;
    end
end

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_pipe2 <= 64'd0;
        addb_pipe2 <= 64'd0;
        i_en_pipe2 <= 1'b0;
    end else if (i_en_pipe1) begin
        adda_pipe2 <= adda_pipe1;
        addb_pipe2 <= addb_pipe1;
        i_en_pipe2 <= 1'b1;
    end else begin
        adda_pipe2 <= adda_pipe2;
        addb_pipe2 <= addb_pipe2;
        i_en_pipe2 <= i_en_pipe2;
    end
end

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_pipe3 <= 64'd0;
        addb_pipe3 <= 64'd0;
        i_en_pipe3 <= 1'b0;
    end else if (i_en_pipe2) begin
        adda_pipe3 <= adda_pipe2;
        addb_pipe3 <= addb_pipe2;
        i_en_pipe3 <= 1'b1;
    end else begin
        adda_pipe3 <= adda_pipe3;
        addb_pipe3 <= addb_pipe3;
        i_en_pipe3 <= i_en_pipe3;
    end
end

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result_pipe <= 65'd0;
    end else if (i_en_pipe3) begin
        sum1 = adda_pipe3[15:0] + addb_pipe3[15:0];
        carry1 = (sum1[15:0] > 16'd65535) ? 1 : 0;
        sum2 = adda_pipe3[31:16] + addb_pipe3[31:16] + carry1;
        carry2 = (sum2[15:0] > 16'd65535) ? 1 : 0;
        sum3 = adda_pipe3[47:32] + addb_pipe3[47:32] + carry2;
        carry3 = (sum3[15:0] > 16'd65535) ? 1 : 0;
        sum4 = adda_pipe3[63:48] + addb_pipe3[63:48] + carry3;
        result_pipe <= {sum4[15:0], sum3[15:0], sum2[15:0], sum1[15:0]};
    end else begin
        result_pipe <= result_pipe;
    end
end

assign result = result_pipe;
assign o_en = (i_en_pipe3) ? 1'b1 : 1'b0;

endmodule
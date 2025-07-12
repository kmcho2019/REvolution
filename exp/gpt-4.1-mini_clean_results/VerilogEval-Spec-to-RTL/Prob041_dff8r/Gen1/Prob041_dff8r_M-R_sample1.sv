module TopModule(
    input        clk,
    input        reset,
    input  [7:0] d,
    output [7:0] q
);

reg q_reg0, q_reg1, q_reg2, q_reg3, q_reg4, q_reg5, q_reg6, q_reg7;

always @(posedge clk) begin
    if (reset)       q_reg0 <= 1'b0;
    else             q_reg0 <= d[0];
end

always @(posedge clk) begin
    if (reset)       q_reg1 <= 1'b0;
    else             q_reg1 <= d[1];
end

always @(posedge clk) begin
    if (reset)       q_reg2 <= 1'b0;
    else             q_reg2 <= d[2];
end

always @(posedge clk) begin
    if (reset)       q_reg3 <= 1'b0;
    else             q_reg3 <= d[3];
end

always @(posedge clk) begin
    if (reset)       q_reg4 <= 1'b0;
    else             q_reg4 <= d[4];
end

always @(posedge clk) begin
    if (reset)       q_reg5 <= 1'b0;
    else             q_reg5 <= d[5];
end

always @(posedge clk) begin
    if (reset)       q_reg6 <= 1'b0;
    else             q_reg6 <= d[6];
end

always @(posedge clk) begin
    if (reset)       q_reg7 <= 1'b0;
    else             q_reg7 <= d[7];
end

assign q = {q_reg7, q_reg6, q_reg5, q_reg4, q_reg3, q_reg2, q_reg1, q_reg0};

endmodule
module BCDCounter(
    input clk,
    input reset,
    input ena,
    output [3:0] q
);

reg [3:0] q_reg;

always @(posedge clk) begin
    if (reset) begin
        q_reg <= 4'd0;
    end else if (ena) begin
        if (q_reg == 4'd9) begin
            q_reg <= 4'd0;
        end else begin
            q_reg <= q_reg + 1'd1;
        end
    end
end

assign q = q_reg;

endmodule

module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] q0, q1, q2, q3;

BCDCounter BCDCounter0(
    .clk(clk),
    .reset(reset),
    .ena(1'b1),
    .q(q0)
);

BCDCounter BCDCounter1(
    .clk(clk),
    .reset(reset),
    .ena(q0 == 4'd9),
    .q(q1)
);

BCDCounter BCDCounter2(
    .clk(clk),
    .reset(reset),
    .ena(q1 == 4'd9),
    .q(q2)
);

BCDCounter BCDCounter3(
    .clk(clk),
    .reset(reset),
    .ena(q2 == 4'd9),
    .q(q3)
);

assign ena[0] = q0 == 4'd9;
assign ena[1] = q1 == 4'd9;
assign ena[2] = q2 == 4'd9;
assign q[3:0] = q0;
assign q[7:4] = q1;
assign q[11:8] = q2;
assign q[15:12] = q3;

endmodule
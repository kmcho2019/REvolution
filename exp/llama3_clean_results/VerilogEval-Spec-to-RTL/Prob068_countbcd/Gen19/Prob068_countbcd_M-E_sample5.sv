module BCDCounterStage(
    input  clk,
    input  reset,
    input  ena,
    output [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'd0;
    end else if (ena) begin
        if (count == 4'd9) begin
            count <= 4'd0;
        end else begin
            count <= count + 1;
        end
    end
end

assign q = count;

endmodule

module CarryLogic(
    input  [3:0] q0,
    input  [3:0] q1,
    input  [3:0] q2,
    output ena0,
    output ena1,
    output ena2
);

assign ena0 = 1'b1;
assign ena1 = (q0 == 4'd9);
assign ena2 = (q1 == 4'd9) && (q0 == 4'd9);

endmodule

module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] q0, q1, q2, q3;

BCDCounterStage stage0(
   .clk(clk),
   .reset(reset),
   .ena(1'b1),
   .q(q0)
);

BCDCounterStage stage1(
   .clk(clk),
   .reset(reset),
   .ena(q0 == 4'd9),
   .q(q1)
);

BCDCounterStage stage2(
   .clk(clk),
   .reset(reset),
   .ena(q1 == 4'd9 && q0 == 4'd9),
   .q(q2)
);

BCDCounterStage stage3(
   .clk(clk),
   .reset(reset),
   .ena(q2 == 4'd9 && q1 == 4'd9 && q0 == 4'd9),
   .q(q3)
);

assign ena[0] = (q0 == 4'd9);
assign ena[1] = (q1 == 4'd9) && (q0 == 4'd9);
assign ena[2] = (q2 == 4'd9) && (q1 == 4'd9) && (q0 == 4'd9);

assign q[3:0] = q0;
assign q[7:4] = q1;
assign q[11:8] = q2;
assign q[15:12] = q3;

endmodule
module BCDCounter(
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

module ControlModule(
    input  clk,
    input  reset,
    output [2:0] ena
);

reg [2:0] ena_reg;

always @(posedge clk) begin
    if (reset) begin
        ena_reg <= 3'b001;
    end else begin
        ena_reg <= {ena_reg[1:0], 1'b1};
    end
end

assign ena = ena_reg;

endmodule

module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] q0, q1, q2, q3;

BCDCounter counter0(
   .clk(clk),
   .reset(reset),
   .ena(1'b1),
   .q(q0)
);

BCDCounter counter1(
   .clk(clk),
   .reset(reset),
   .ena(q0 == 4'd9),
   .q(q1)
);

BCDCounter counter2(
   .clk(clk),
   .reset(reset),
   .ena(q0 == 4'd9 && q1 == 4'd9),
   .q(q2)
);

BCDCounter counter3(
   .clk(clk),
   .reset(reset),
   .ena(q0 == 4'd9 && q1 == 4'd9 && q2 == 4'd9),
   .q(q3)
);

assign q = {q3, q2, q1, q0};
assign ena[0] = (q0 == 4'd9);
assign ena[1] = (q1 == 4'd9) && (q0 == 4'd9);
assign ena[2] = (q2 == 4'd9) && (q1 == 4'd9) && (q0 == 4'd9);

endmodule
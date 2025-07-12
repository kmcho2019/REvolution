module BCDCounter(
    input  clk,
    input  reset,
    input  ena,
    output [3:0] q,
    output carry
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'd0;
    end else if (ena) begin
        if (count == 4'd9) begin
            count <= 4'd0;
            carry <= 1'b1;
        end else begin
            count <= count + 1;
            carry <= 1'b0;
        end
    end
end

assign q = count;

endmodule

module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

wire carry1, carry2, carry3;

BCDCounter counter0(
   .clk(clk),
   .reset(reset),
   .ena(1'b1),
   .q(q[3:0]),
   .carry(carry1)
);

BCDCounter counter1(
   .clk(clk),
   .reset(reset),
   .ena(carry1),
   .q(q[7:4]),
   .carry(carry2)
);

BCDCounter counter2(
   .clk(clk),
   .reset(reset),
   .ena(carry2),
   .q(q[11:8]),
   .carry(carry3)
);

BCDCounter counter3(
   .clk(clk),
   .reset(reset),
   .ena(carry3),
   .q(q[15:12]),
   .carry()
);

assign ena[0] = carry1;
assign ena[1] = carry2;
assign ena[2] = carry3;

endmodule
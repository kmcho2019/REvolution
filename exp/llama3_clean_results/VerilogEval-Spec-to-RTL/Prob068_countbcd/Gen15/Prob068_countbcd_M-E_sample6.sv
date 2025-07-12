module DigitModule(
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
        end else begin
            count <= count + 1;
        end
    end
end

assign q = count;
assign carry = (count == 4'd9) && ena;

endmodule

module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

wire carry1, carry2, carry3;

DigitModule digit0(
   .clk(clk),
   .reset(reset),
   .ena(1'b1),
   .q(q[3:0]),
   .carry(carry1)
);

DigitModule digit1(
   .clk(clk),
   .reset(reset),
   .ena(carry1),
   .q(q[7:4]),
   .carry(carry2)
);

DigitModule digit2(
   .clk(clk),
   .reset(reset),
   .ena(carry2),
   .q(q[11:8]),
   .carry(carry3)
);

DigitModule digit3(
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
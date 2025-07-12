module BCD_Counter(
    input  clk,
    input  reset,
    input  ena,
    input  carry_in,
    output [3:0] q,
    output carry_out
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'd0;
    end else if (ena || carry_in) begin
        if (count == 4'd9) begin
            count <= 4'd0;
            carry_out <= 1'b1;
        end else begin
            count <= count + 1;
            carry_out <= 1'b0;
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

BCD_Counter ones(
    .clk(clk),
    .reset(reset),
    .ena(1'b1),
    .carry_in(1'b0),
    .q(q[3:0]),
    .carry_out(carry1)
);

BCD_Counter tens(
    .clk(clk),
    .reset(reset),
    .ena(carry1),
    .carry_in(1'b0),
    .q(q[7:4]),
    .carry_out(carry2)
);

BCD_Counter hundreds(
    .clk(clk),
    .reset(reset),
    .ena(carry2),
    .carry_in(1'b0),
    .q(q[11:8]),
    .carry_out(carry3)
);

BCD_Counter thousands(
    .clk(clk),
    .reset(reset),
    .ena(carry3),
    .carry_in(1'b0),
    .q(q[15:12]),
    .carry_out()
);

assign ena[0] = carry1;
assign ena[1] = carry2;
assign ena[2] = carry3;

endmodule
module Digit(
    input  clk,
    input  reset,
    input  ena,
    output [3:0] q,
    output ena_next
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'd0;
    end else if (ena) begin
        count <= (count == 4'd9) ? 4'd0 : count + 1;
    end
end

assign q = count;
assign ena_next = (count == 4'd9) && ena;

endmodule

module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

Digit digit0(
    .clk(clk),
    .reset(reset),
    .ena(1'b1),
    .q(q[3:0]),
    .ena_next(ena[0])
);

Digit digit1(
    .clk(clk),
    .reset(reset),
    .ena(ena[0]),
    .q(q[7:4]),
    .ena_next(ena[1])
);

Digit digit2(
    .clk(clk),
    .reset(reset),
    .ena(ena[1]),
    .q(q[11:8]),
    .ena_next(ena[2])
);

Digit digit3(
    .clk(clk),
    .reset(reset),
    .ena(ena[2]),
    .q(q[15:12]),
    .ena_next()
);

endmodule
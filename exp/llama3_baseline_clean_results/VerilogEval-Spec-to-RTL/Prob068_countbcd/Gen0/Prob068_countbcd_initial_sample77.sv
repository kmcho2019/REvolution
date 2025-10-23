module BCD_Digit(
    input clk,
    input reset,
    input ena,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 0;
    end else if (ena) begin
        if (q == 9) begin
            q <= 0;
        end else begin
            q <= q + 1;
        end
    end
end

endmodule

module TopModule(
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

reg [3:0] ones, tens, hundreds, thousands;

assign q[3:0] = ones;
assign q[7:4] = tens;
assign q[11:8] = hundreds;
assign q[15:12] = thousands;

BCD_Digit ones_digit(
   .clk(clk),
   .reset(reset),
   .ena(1'b1),
   .q(ones)
);

BCD_Digit tens_digit(
   .clk(clk),
   .reset(reset),
   .ena(ones == 9),
   .q(tens)
);

BCD_Digit hundreds_digit(
   .clk(clk),
   .reset(reset),
   .ena(tens == 9),
   .q(hundreds)
);

BCD_Digit thousands_digit(
   .clk(clk),
   .reset(reset),
   .ena(hundreds == 9),
   .q(thousands)
);

always @(posedge clk) begin
    if (reset) begin
        ena <= 0;
    end else begin
        ena[0] <= ones == 9;
        ena[1] <= tens == 9;
        ena[2] <= hundreds == 9;
    end
end

endmodule
module BCDCounter(
    input clk,
    input reset,
    input ena,
    output reg [3:0] q,
    output reg carry
);

always @(posedge clk) begin
    if (reset) begin
        q <= 0;
        carry <= 0;
    end else if (ena) begin
        if (q == 9) begin
            q <= 0;
            carry <= 1;
        end else begin
            q <= q + 1;
            carry <= 0;
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

reg [3:0] ones_digit;
reg [3:0] tens_digit;
reg [3:0] hundreds_digit;
reg [3:0] thousands_digit;

BCDCounter ones( clk, reset, 1'b1, ones_digit, ena[0] );
BCDCounter tens( clk, reset, ena[0], tens_digit, ena[1] );
BCDCounter hundreds( clk, reset, ena[1], hundreds_digit, ena[2] );
BCDCounter thousands( clk, reset, ena[2], thousands_digit, );

assign q[3:0] = ones_digit;
assign q[7:4] = tens_digit;
assign q[11:8] = hundreds_digit;
assign q[15:12] = thousands_digit;

endmodule
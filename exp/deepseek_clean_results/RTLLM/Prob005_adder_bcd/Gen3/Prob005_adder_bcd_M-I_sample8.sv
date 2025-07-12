module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output reg [3:0] Sum,
    output reg Cout
);

wire [3:0] raw_sum;
wire raw_carry;
wire needs_correction;

// First stage: Binary addition
assign {raw_carry, raw_sum} = A + B + Cin;

// Correction needed if:
// 1) Raw sum > 9 (invalid BCD) OR
// 2) Raw carry is set (sum >= 16)
assign needs_correction = (raw_sum > 4'd9) | raw_carry;

// Second stage: Conditional correction
always @(*) begin
    if (needs_correction) begin
        Sum = raw_sum + 4'd6;
        Cout = 1'b1;
    end
    else begin
        Sum = raw_sum;
        Cout = 1'b0;
    end
end

endmodule
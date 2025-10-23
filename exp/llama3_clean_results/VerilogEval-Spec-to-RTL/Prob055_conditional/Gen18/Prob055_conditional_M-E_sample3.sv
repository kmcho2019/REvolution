module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

wire [1:0] min_code;

assign min_code[0] = (a < b) & (a < c) & (a < d) | (b < c) & (b < d) & (a == b) | (c < d) & (a == c) & (b == c) | (a == d) & (b == d) & (c == d);
assign min_code[1] = (b < a) & (b < c) & (b < d) | (a < c) & (a < d) & (b == a) | (c < d) & (b == c) & (a == c) | (b == d) & (a == d) & (c == d);

always @(*) begin
    case (min_code)
        2'b00: min = a;
        2'b01: min = b;
        2'b10: min = c;
        2'b11: min = d;
        default: min = 8'b0;
    endcase
end

endmodule
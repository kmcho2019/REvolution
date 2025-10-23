module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

wire [1:0] ab;
assign ab = {a, b};

reg [1:0] lut00, lut01, lut10, lut11;
always @(*) begin
    case (ab)
        2'b00: out = (c == 1'b0 && d == 1'b0) ? 1'b0 : (c == 1'b0 && d == 1'b1) ? 1'b1 : (c == 1'b1 && d == 1'b0) ? 1'b1 : 1'b0;
        2'b01: out = (c == 1'b0 && d == 1'b0) ? 1'b1 : (c == 1'b0 && d == 1'b1) ? 1'b0 : (c == 1'b1 && d == 1'b0) ? 1'b0 : 1'b1;
        2'b10: out = (c == 1'b0 && d == 1'b0) ? 1'b1 : (c == 1'b0 && d == 1'b1) ? 1'b0 : (c == 1'b1 && d == 1'b0) ? 1'b1 : 1'b0;
        2'b11: out = (c == 1'b0 && d == 1'b0) ? 1'b0 : (c == 1'b0 && d == 1'b1) ? 1'b1 : (c == 1'b1 && d == 1'b0) ? 1'b0 : 1'b1;
        default: out = 1'b0;
    endcase
end

endmodule
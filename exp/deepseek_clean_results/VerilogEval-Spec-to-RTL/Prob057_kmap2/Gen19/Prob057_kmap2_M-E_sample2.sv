module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

wire [1:0] cd = {c,d};
wire [1:0] ab = {a,b};

reg intermediate;

always @(*) begin
    case(cd)
        2'b00: intermediate = (ab != 2'b11); // 1 for all ab except 11
        2'b01: intermediate = (ab == 2'b00) || (ab == 2'b10);
        2'b11: intermediate = (ab != 2'b00) && (ab != 2'b10);
        2'b10: intermediate = (ab == 2'b00) || (ab == 2'b01) || (ab == 2'b11);
        default: intermediate = 1'b0;
    endcase
end

assign out = intermediate;

endmodule
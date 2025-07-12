module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

reg [3:0] q;

always @(*) begin
    case (c[1:0])
        2'b00: q = (c[3:2] != 2'b00) ? 4'b1111 : b;
        2'b01: q = (c[3:2] != 2'b00) ? 4'b1111 : e;
        2'b10: q = (c[3:2] != 2'b00) ? 4'b1111 : a;
        2'b11: q = (c[3:2] != 2'b00) ? 4'b1111 : d;
        default: q = 4'b1111;
    endcase
end

endmodule
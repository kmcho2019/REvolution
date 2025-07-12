module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q
);

reg [3:0] sel;
reg [3:0] default;

always @(*) begin
    case (c[1:0])
        2'b00: sel = b;
        2'b01: sel = e;
        2'b10: sel = a;
        2'b11: sel = d;
    endcase

    default = (c[3:2] == 2'b00) ? 4'b0000 : 4'b1111;
end

always @(*) begin
    q = (c[3:2] == 2'b00) ? sel : default;
end

endmodule
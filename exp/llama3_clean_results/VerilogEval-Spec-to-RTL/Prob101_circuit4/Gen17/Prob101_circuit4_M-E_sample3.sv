module MUX_4to1(
    input  [1:0] sel,
    input  [3:0] in,
    output reg out
);

always @(*) begin
    case (sel)
        2'b00: out = in[0];
        2'b01: out = in[1];
        2'b10: out = in[2];
        2'b11: out = in[3];
        default: out = 1'bx;
    endcase
end

endmodule

module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg q
);

reg [1:0] sel;
reg [3:0] in;

always @(*) begin
    sel = {a, d};
    in = {1'b0, b, c, 1'b1};
end

MUX_4to1 mux_4to1(
    .sel(sel),
    .in(in),
    .out(q)
);

endmodule
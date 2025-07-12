module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q
);

reg [1:0] sel;

always @(*) begin
    case (c[1:0])
        2'b00: sel = 2'b00; // select b
        2'b01: sel = 2'b01; // select e
        2'b10: sel = 2'b10; // select a
        2'b11: sel = 2'b11; // select d
        default: sel = 2'b11; // default to select d
    endcase
end

always @(*) begin
    case (sel)
        2'b00: q = b;
        2'b01: q = e;
        2'b10: q = a;
        2'b11: q = d;
        default: q = d; // default to d
    endcase
end

endmodule
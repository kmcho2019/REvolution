module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q
);

wire [3:0] f = a | b | d | e;

always @(*) begin
    case (c)
        4'h0: q = b;
        4'h1: q = e;
        4'h2: q = a;
        4'h3: q = d;
        4'h4: q = f;
        default: q = f;
    endcase
end

endmodule
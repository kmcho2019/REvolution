module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q
);

always @(*) begin
    case (c[1:0])
        2'b00: q = (c[0] == 1'b0)? b : e;
        2'b01: q = a;
        2'b10: q = d;
        default: q = 4'b1111; // assuming 'f' as don't care
    endcase
end

endmodule
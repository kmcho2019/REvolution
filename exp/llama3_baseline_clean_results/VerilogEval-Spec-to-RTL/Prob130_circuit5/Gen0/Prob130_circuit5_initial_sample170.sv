module TopModule(
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

always @(*)
begin
    case(c[1:0])
        2'b00: q = b; // c is 0
        2'b01: q = e; // c is 1
        2'b10: q = a; // c is 2
        2'b11: q = d; // c is 3
        default: q = 4'bxxxx; // all other values of c
    endcase
end

endmodule
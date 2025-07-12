module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q
);

always @(*)
    case (c[1:0])
        2'b00: q = (c[0] == 0) ? b : e;
        2'b01: q = (c[0] == 0) ? a : d;
        default: q = 4'b1111; // Default value for c >= 4'b0011
    endcase

endmodule
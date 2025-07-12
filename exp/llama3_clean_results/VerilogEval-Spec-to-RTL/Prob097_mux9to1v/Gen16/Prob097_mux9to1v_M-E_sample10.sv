module TopModule(
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    input  [15:0] d,
    input  [15:0] e,
    input  [15:0] f,
    input  [15:0] g,
    input  [15:0] h,
    input  [15:0] i,
    input  [3:0] sel,
    output [15:0] out
);

reg [15:0] out_reg;

always @(*)
begin
    case (sel)
        4'b0000: out_reg = a;
        4'b0001: out_reg = b;
        4'b0010: out_reg = c;
        4'b0011: out_reg = d;
        4'b0100: out_reg = e;
        4'b0101: out_reg = f;
        4'b0110: out_reg = g;
        4'b0111: out_reg = h;
        4'b1000: out_reg = i;
        default: out_reg = 16'hFFFF;
    endcase
end

assign out = out_reg;

endmodule
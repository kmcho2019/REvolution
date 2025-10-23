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
    input  [3:0]  sel,
    output [15:0] out
);

reg [15:0] out_reg;

always @(*)
begin
    casex(sel)
        4'd0: out_reg = a;
        4'd1: out_reg = b;
        4'd2: out_reg = c;
        4'd3: out_reg = d;
        4'd4: out_reg = e;
        4'd5: out_reg = f;
        4'd6: out_reg = g;
        4'd7: out_reg = h;
        4'd8: out_reg = i;
        default: out_reg = 16'd65535;
    endcase
end

assign out = out_reg;

endmodule
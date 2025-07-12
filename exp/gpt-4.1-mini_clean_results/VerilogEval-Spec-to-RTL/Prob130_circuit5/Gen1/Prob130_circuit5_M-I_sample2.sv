module TopModule (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

wire [3:0] mux_out;
assign mux_out = (c[1:0] == 2'b00) ? b :
                 (c[1:0] == 2'b01) ? e :
                 (c[1:0] == 2'b10) ? a :
                 d;

assign q = (c[3:2] == 2'b00) ? mux_out : 4'hF;

endmodule
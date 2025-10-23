module TopModule (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

wire [3:0] inputs_array [3:0];

assign inputs_array[0] = b;
assign inputs_array[1] = e;
assign inputs_array[2] = a;
assign inputs_array[3] = d;

assign q = (c < 4) ? inputs_array[c] : 4'hF;

endmodule
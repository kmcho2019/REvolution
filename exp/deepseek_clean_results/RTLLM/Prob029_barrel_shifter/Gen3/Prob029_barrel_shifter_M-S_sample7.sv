module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    assign out = ctrl[2] ? {in[3:0], in[7:4]} : in;
    assign out = ctrl[1] ? {out[1:0], out[7:2]} : out;
    assign out = ctrl[0] ? {out[0], out[7:1]} : out;
endmodule
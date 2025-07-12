module TopModule (
    input  [2:0] in,
    output      out0,
    output      out1
);

assign out0 = in[0] ^ in[1] ^ in[2]; // parity bit (LSB of count)
assign out1 = (in[0] & in[1]) | (in[1] & in[2]) | (in[0] & in[2]); // majority (MSB of count)

assign out = {out1, out0};

endmodule
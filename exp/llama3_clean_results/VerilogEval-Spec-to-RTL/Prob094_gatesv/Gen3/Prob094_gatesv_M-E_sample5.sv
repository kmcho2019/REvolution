module TopModule(
    input  [3:0] in,
    output [2:0] out_both,
    output [2:0] out_any,
    output [3:0] out_different
);

// Calculate out_both using shift and bitwise AND
assign out_both = (in >> 1) & in;

// Calculate out_any using shift and bitwise OR
assign out_any[2:1] = (in >> 1) | in;
assign out_any[0] = in[0] | in[3]; // Handle wrap-around for leftmost bit

// Calculate out_different using XOR and circular shift
assign out_different[3] = in[3] ^ in[0];
assign out_different[2:0] = in[2:0] ^ (in >> 1);

endmodule
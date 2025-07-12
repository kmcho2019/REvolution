module TopModule(
    input  [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

wire [2:0] vec_wires;
assign vec_wires = vec;
assign outv = vec_wires;
assign o2 = vec_wires[2];
assign o1 = vec_wires[1];
assign o0 = vec_wires[0];

endmodule
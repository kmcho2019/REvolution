module TopModule(
    input [254:0] in,
    output [7:0] out
);

assign out = $countones(in)[7:0];

endmodule
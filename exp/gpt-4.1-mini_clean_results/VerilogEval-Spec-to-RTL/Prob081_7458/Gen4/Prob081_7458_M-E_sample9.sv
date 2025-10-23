module TopModule (
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p1e,
    input  p1f,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,
    output p2y
);

wire [1:0] p1_and_outputs;
wire [1:0] p2_and_outputs;

assign p1_and_outputs[0] = p1a & p1b & p1c;
assign p1_and_outputs[1] = p1d & p1e & p1f;

assign p2_and_outputs[0] = p2a & p2b;
assign p2_and_outputs[1] = p2c & p2d;

assign p1y = |p1_and_outputs; // OR reduce the 2-bit vector
assign p2y = |p2_and_outputs; // OR reduce the 2-bit vector

endmodule
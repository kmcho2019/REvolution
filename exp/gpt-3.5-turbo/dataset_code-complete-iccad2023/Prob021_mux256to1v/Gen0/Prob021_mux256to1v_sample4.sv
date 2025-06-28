module TopModule (
  input [1023:0] in,
  input [7:0] sel,
  output [3:0] out
);

wire [255:0] selected_input;

assign selected_input = {
  in[sel*4 + 3 +: 1],
  in[sel*4 + 2 +: 1],
  in[sel*4 + 1 +: 1],
  in[sel*4 +: 1]
};

assign out = selected_input;

endmodule
module TopModule (
  input [1023:0] in,
  input [7:0] sel,
  output [3:0] out
);

  reg [3:0] mux_out;

  reg [3:0] in_sel [255:0]; // 2D array to store all the 4-bit inputs

  integer i;
  generate
    for (i = 0; i < 256; i = i + 1) begin : GEN_MUX_INPUTS
      assign in_sel[i] = in[(i*4) +: 4];
    end
  endgenerate

  always @* begin
    mux_out = in_sel[sel];
  end

  assign out = mux_out;

endmodule
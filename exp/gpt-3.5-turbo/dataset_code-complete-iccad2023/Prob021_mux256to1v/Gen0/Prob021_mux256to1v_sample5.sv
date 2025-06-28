module TopModule (
  input [1023:0] in,
  input [7:0] sel,
  output [3:0] out
);

reg [3:0] mux_output;

always @*
begin
  case(sel)
    0: mux_output = in[3:0];
    1: mux_output = in[7:4];
    2: mux_output = in[11:8];
    // Add more cases for all 256 selections
    default: mux_output = 4'd0; // Default case when sel is out of range
  endcase
end

assign out = mux_output;

endmodule
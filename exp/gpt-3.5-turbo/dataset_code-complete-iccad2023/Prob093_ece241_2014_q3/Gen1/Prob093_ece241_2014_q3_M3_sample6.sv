module TopModule (
  input c, input d,
  output reg [3:0] mux_in
);

  always @*
  begin
    case({c, d})
      2'b00: mux_in = 4'b1001; // ab=00
      2'b01: mux_in = 4'b1000; // ab=01
      2'b11: mux_in = 4'b1101; // ab=11
      2'b10: mux_in = 4'b1001; // ab=10
      default: mux_in = 4'b0; // default case
    endcase
  end

endmodule
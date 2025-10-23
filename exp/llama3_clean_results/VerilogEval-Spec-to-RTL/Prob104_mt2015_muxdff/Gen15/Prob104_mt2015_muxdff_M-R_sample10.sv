module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  output reg Q
);

  reg internal_Q;

  assign Q = internal_Q;

  always @(posedge clk) begin
    case ({L})
      1'b1: internal_Q <= r_in;
      1'b0: internal_Q <= q_in;
    endcase
  end

endmodule
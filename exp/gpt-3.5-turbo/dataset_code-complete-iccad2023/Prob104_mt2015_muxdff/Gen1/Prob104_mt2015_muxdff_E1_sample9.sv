module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  output reg Q
);

  reg q_ff; // D flip-flop output

  always @ (posedge clk) begin
    if (L) begin
      q_ff <= r_in;
    end
  end

  assign Q = L ? q_ff : {q_ff[1] ^ q_ff[2], q_ff[0], q_ff[2]};

endmodule
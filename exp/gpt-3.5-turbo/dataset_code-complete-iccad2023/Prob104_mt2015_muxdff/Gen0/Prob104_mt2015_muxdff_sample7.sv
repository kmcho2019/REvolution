module TopModule (
  input clk,
  input L,
  input q_in, // previous state of q
  input r_in, // load value
  output reg Q // output
);
  reg [2:0] q_ff; // flip-flop to store q

  always @(posedge clk) begin
    if (L) begin
      q_ff <= r_in;
    end else begin
      q_ff <= {q_ff[1] ^ q_ff[2], q_ff[0], q_ff[2]};
    end
  end

  assign Q = L ? r_in : q_ff[q_in];
endmodule
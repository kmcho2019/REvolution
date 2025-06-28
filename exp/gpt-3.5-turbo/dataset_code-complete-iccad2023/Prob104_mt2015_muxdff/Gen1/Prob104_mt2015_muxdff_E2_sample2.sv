module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  output reg [2:0] Q
);

  always @ (posedge clk) begin
    if (L) begin
      Q <= r_in; // Load r_in into Q if L is asserted
    end else begin
      Q <= {Q[1] ^ Q[2], q_in, Q[2]}; // Perform the logic function on existing Q values
    end
  end

endmodule
module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  output reg Q
);

  reg [2:0] DFF_out;
  
  always @ (posedge clk) begin
    if (L) begin
      DFF_out <= r_in;
    end else begin
      DFF_out <= {DFF_out[1] ^ DFF_out[2], DFF_out[0], DFF_out[2]};
    end
  end

  assign Q = L ? r_in : DFF_out[2];

endmodule
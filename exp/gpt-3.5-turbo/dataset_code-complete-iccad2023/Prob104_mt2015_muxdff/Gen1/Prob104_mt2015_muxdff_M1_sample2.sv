module TopModule (
  input clk,
  input L,
  input [2:0] q_in, // Change to a 3-bit vector
  input [2:0] r_in, // Change to a 3-bit vector
  output reg [2:0] Q // Change to a 3-bit vector
);

reg [2:0] mux_out;
reg [2:0] ff_out;

always @* begin
  mux_out = L ? r_in : {q_in[1] ^ q_in[2], q_in[0], q_in[2]};
end

always @(posedge clk) begin
  ff_out <= mux_out;
end

assign Q = ff_out;

endmodule
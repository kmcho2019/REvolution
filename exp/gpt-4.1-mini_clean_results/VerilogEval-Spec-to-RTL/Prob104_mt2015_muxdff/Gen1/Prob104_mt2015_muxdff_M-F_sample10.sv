module TopModule(
  input clk,
  input reset, // synchronous active-high reset added
  input L,
  input q_in,
  input r_in,
  output reg Q
);

wire mux_out;

// 2:1 multiplexer: if L=1 select r_in else q_in
assign mux_out = L ? r_in : q_in;

// D flip-flop with synchronous reset and synchronous load controlled by mux_out
always @(posedge clk) begin
  if (reset) begin
    Q <= 1'b0;
  end else begin
    Q <= mux_out;
  end
end

endmodule
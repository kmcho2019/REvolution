module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  output reg Q
);
  
  reg [1:0] ff; // 2 flip-flops for internal storage
  
  always @(posedge clk) begin
    if (L) begin
      ff <= r_in[1:0]; // load new value if L is asserted
    end
  end
  
  assign Q = (L) ? {ff, 1'b0} : {q_in, ff[1]}; // Mux select between q_in and ff based on L

endmodule
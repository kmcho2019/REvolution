module TopModule (
  input clk,
  input x,
  output reg z
);

reg [2:0] state;
wire d1, d2, d3;

assign d1 = x ^ state[0];
assign d2 = ~(x & state[1]);
assign d3 = ~state[2];

always @(posedge clk) begin
  case (state)
    3'd0: begin
      z <= d1 | d2 | d3;
      state <= x ^ state;
    end
    3'd1: begin
      z <= d1 & d2 & d3;
      state <= x ^ state;
    end
    3'd2: begin
      z <= d1 | d2 | d3;
      state <= x ^ state;
    end
    3'd3: begin
      z <= d1 & d2 & d3;
      state <= x ^ state;
    end
  endcase
end

endmodule
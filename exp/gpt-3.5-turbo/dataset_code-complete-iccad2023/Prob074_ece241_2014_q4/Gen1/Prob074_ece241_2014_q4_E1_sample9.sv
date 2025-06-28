module TopModule (
  input clk,
  input x,
  output reg z
);

reg [2:0] state;
wire [2:0] next_state;

assign next_state[0] = x ^ state[0];
assign next_state[1] = ~(x & state[1]);
assign next_state[2] = ~state[2];

always @(*) begin
  case (state)
    3'd0: begin
      z = x ^ state[0] | ~(x & state[1]) | ~state[2];
    end
    3'd1: begin
      z = x ^ state[0] & ~(x & state[1]) & ~state[2];
    end
    3'd2: begin
      z = x ^ state[0] | ~(x & state[1]) | ~state[2];
    end
    3'd3: begin
      z = x ^ state[0] & ~(x & state[1]) & ~state[2];
    end
  endcase
end

always @(posedge clk) begin
  state <= next_state;
end

endmodule
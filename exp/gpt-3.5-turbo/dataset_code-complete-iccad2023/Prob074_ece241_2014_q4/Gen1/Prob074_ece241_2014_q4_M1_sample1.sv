module TopModule (
  input clk,
  input x,
  output reg z
);

reg [2:0] state;
reg d1, d2, d3;

always @* begin
  case (state)
    3'd0: begin
      d1 = x ^ state[0];
      d2 = ~(x & state[1]);
      d3 = ~state[2];
    end
    3'd1: begin
      d1 = x ^ state[0];
      d2 = ~(x & state[1]);
      d3 = ~state[2];
    end
    3'd2: begin
      d1 = x ^ state[0];
      d2 = ~(x & state[1]);
      d3 = ~state[2];
    end
    3'd3: begin
      d1 = x ^ state[0];
      d2 = ~(x & state[1]);
      d3 = ~state[2];
    end
  endcase
end

always @(posedge clk) begin
  case (state)
    3'd0: begin
      z <= d1 | d2 | d3;
      state <= x;
    end
    3'd1: begin
      z <= d1 & d2 & d3;
      state <= x;
    end
    3'd2: begin
      z <= d1 | d2 | d3;
      state <= x;
    end
    3'd3: begin
      z <= d1 & d2 & d3;
      state <= x;
    end
  endcase
end

endmodule
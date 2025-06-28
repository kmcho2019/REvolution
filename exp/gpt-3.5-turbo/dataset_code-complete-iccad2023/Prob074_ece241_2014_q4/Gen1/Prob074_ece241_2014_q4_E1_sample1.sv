module FSM (
  input clk,
  input x,
  output reg z
);

reg [2:0] state;
reg d1, d2, d3;

// D flip-flops
always @(posedge clk) begin
  case (state)
    3'd0: d1 <= x ^ state[0];
    3'd1: d2 <= ~(x & state[1]);
    3'd2: d3 <= ~state[2];
    3'd3: begin
      d1 <= x ^ state[0];
      d2 <= ~(x & state[1]);
      d3 <= ~state[2];
    end
  endcase
end

// State transition logic
always @(posedge clk) begin
  case (state)
    3'd0: state <= x ^ state;
    3'd1: state <= x ^ state;
    3'd2: state <= x ^ state;
    3'd3: state <= x ^ state;
  endcase
end

// Output Z generation
assign z = ~(d1 | d2 | d3);

endmodule
module TopModule (
  input clock,
  input a,
  output reg p,
  output reg q
);

reg [1:0] state, next_state;

always @* begin
  case (state)
    0: begin // Idle state
      p <= 0;
      q <= 0;
      if (a) next_state <= 1;
      else next_state <= 0;
    end
    1: begin // Set state
      if (a) begin
        p <= 1;
        q <= 1;
      end
      next_state <= 2;
    end
    2: begin // Clear state
      p <= p;
      q <= 0;
      next_state <= 3;
    end
    3: begin // Toggle state
      p <= 0;
      q <= p;
      next_state <= 0;
    end
  endcase
end

always @(posedge clock) begin
  state <= next_state;
end

endmodule
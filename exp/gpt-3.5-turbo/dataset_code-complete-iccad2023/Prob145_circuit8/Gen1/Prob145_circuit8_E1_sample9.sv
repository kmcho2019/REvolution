module TopModule (
  input clock,
  input a,
  output reg p,
  output reg q
);

// State definition
parameter idle = 2'b00;
parameter p_active = 2'b01;
parameter pq_active = 2'b10;
reg [1:0] state, next_state;

always @* begin
  // State transitions based on current state and inputs
  case (state)
    idle: begin
      if (a) begin
        next_state = p_active;
      end else begin
        next_state = idle;
      end
    end
    p_active: begin
      next_state = pq_active;
    end
    pq_active: begin
      next_state = (a) ? pq_active : idle;
    end
    default: next_state = idle;
  endcase
end

always @(posedge clock) begin
  state <= next_state; // Update state on clock rising edge
  // Output control based on current state
  case (state)
    idle: begin
      p <= 0;
      q <= 0;
    end
    p_active: begin
      p <= a;
      q <= 0;
    end
    pq_active: begin
      p <= a;
      q <= 1;
    end
    default: begin
      p <= 0;
      q <= 0;
    end
  endcase
end

endmodule
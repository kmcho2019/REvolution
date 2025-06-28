module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

// Enumeration for state encoding
parameter IDLE = 1'b0, RECEIVE = 1'b1;
reg state, next_state;
reg [2:0] counter;

always @ (posedge clk) begin
  if (reset) begin
    state <= IDLE;
    counter <= 0;
    done <= 0;
  end
  else begin
    state <= next_state;
    counter <= (state == RECEIVE) ? (counter + 1) : 0;
    
    if (state == RECEIVE && counter == 8) begin
      if (in == 1) begin
        done <= 1;
        next_state <= IDLE;
      end
      else begin
        next_state <= RECEIVE;
      end
    end
    else if (state == IDLE && in == 0) begin
      next_state <= RECEIVE;
    end
    else if (state == RECEIVE) begin
      next_state <= RECEIVE;
    end
    else begin
      next_state <= IDLE;
    end
  end
end

endmodule
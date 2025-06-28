module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

// Enumeration for state encoding
parameter IDLE = 2'b00, START_BIT = 2'b01, DATA_BITS = 2'b10, STOP_BIT = 2'b11;
reg [1:0] state, next_state;
reg [2:0] counter;

always @ (posedge clk) begin
  if (reset) begin
    state <= IDLE;
    counter <= 0;
    done <= 0;
  end
  else begin
    state <= next_state;
    counter <= (state == DATA_BITS || state == STOP_BIT) ? (counter + 1) : 0;
    done <= (state == STOP_BIT && counter == 1 && in) ? 1 : 0;
  end
end

always @ (*) begin
  next_state = state;
  case (state)
    IDLE: begin
      if (in == 0) begin
        next_state = START_BIT;
      end
    end
    START_BIT: begin
      if (counter == 8) begin
        next_state = DATA_BITS;
      end
    end
    DATA_BITS: begin
      if (counter == 8) begin
        next_state = STOP_BIT;
      end
    end
    STOP_BIT: begin
      if (counter == 1) begin
        if (in == 1) begin
          next_state = IDLE;
        end
        else begin
          next_state = START_BIT;
        end
      end
    end
  endcase
end

endmodule
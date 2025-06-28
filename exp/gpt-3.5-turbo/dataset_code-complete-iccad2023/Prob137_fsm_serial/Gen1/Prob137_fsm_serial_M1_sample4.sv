module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

// Enumeration for state encoding
parameter IDLE = 2'b00, START_BIT = 2'b01, DATA_BITS = 2'b10;
reg [1:0] state, next_state;
reg [4:0] counter;

always @ (posedge clk) begin
  if (reset) begin
    state <= IDLE;
    counter <= 0;
    done <= 0;
  end
  else begin
    state <= next_state;
    counter <= (state == DATA_BITS) ? (counter + 1) : 0;
    done <= (state == DATA_BITS && counter == 8 && in) ? 1 : 0;
  end
end

always @ (*) begin
  next_state = state;
  case (state)
    IDLE: begin
      if (in == 0) begin
        next_state = START_BIT;
        counter <= 0;
      end
    end
    START_BIT: begin
      if (counter == 0) begin
        next_state = DATA_BITS;
        counter <= 0;
      end
      else if (in == 1) begin
        next_state = IDLE;
        counter <= 0;
      end
    end
    DATA_BITS: begin
      if (counter == 0) begin
        if (in == 1) begin
          next_state = IDLE;
          counter <= 0;
        end
      end
    end
  endcase
end

endmodule
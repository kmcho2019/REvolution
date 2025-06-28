module TopModule (
  input clk,
  input in,
  input reset,
  output reg [7:0] out_byte,
  output reg done
);

// Define states
parameter IDLE = 2'b00, START_BIT = 2'b01, RECEIVE_DATA = 2'b10, STOP_BIT = 2'b11;
reg [1:0] state, next_state;

always @ (posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
    out_byte <= 8'b0;
    done <= 0;
  end
  else begin
    state <= next_state;
  end
end

always @ (*) begin
  case (state)
    IDLE: begin
      if (in == 1'b0) begin
        next_state = START_BIT; // Detect start bit
      else
        next_state = IDLE;
      end
    end
    START_BIT: begin
      next_state = RECEIVE_DATA; // Start receiving data bits
    end
    RECEIVE_DATA: begin
      out_byte <= {out_byte[6:0], in}; // Shift data bits
      if ($unsigned(out_byte) == 8'd255) begin // Check if all data bits are received
        next_state = STOP_BIT;
      end else begin
        next_state = RECEIVE_DATA;
      end
    end
    STOP_BIT: begin
      if (in == 1'b1) begin
        done = 1;
        next_state = IDLE; // Wait for start bit
      else
        next_state = STOP_BIT;
      end
    end
    default: next_state = IDLE;
  endcase
end

endmodule
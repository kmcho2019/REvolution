module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg done
);

// Define states
parameter IDLE = 2'b00;
parameter BYTE1 = 2'b01;
parameter BYTE2 = 2'b10;
parameter DONE = 2'b11;
parameter ERROR = 2'bxx;  // New state to capture error condition

// Define signals
reg [1:0] state, next_state;

// Sequential logic
always @(posedge clk) begin
  if (reset) begin
    state <= IDLE;
  end else begin
    state <= next_state;
  end
end

// Combinational logic
always @(*) begin
  // Default next state
  next_state = state;

  case (state)
    IDLE: begin
      if (in[3] == 1) begin
        next_state = BYTE1;
      end
    end

    BYTE1: begin
      if (in[3] == 0) begin
        next_state = ERROR;  // Unexpected data received, enter error state
      end else begin
        next_state = BYTE2;
      end
    end

    BYTE2: begin
      if (in[3] == 0) begin
        next_state = ERROR;  // Unexpected data received, enter error state
      end else begin
        next_state = DONE;
      end
    end

    DONE: begin
      next_state = IDLE;  // Reset to IDLE after message completion
    end

    ERROR: begin
      next_state = IDLE;  // Reset to IDLE after error detection
    end
  endcase
end

// Output logic
assign done = (state == DONE);

endmodule
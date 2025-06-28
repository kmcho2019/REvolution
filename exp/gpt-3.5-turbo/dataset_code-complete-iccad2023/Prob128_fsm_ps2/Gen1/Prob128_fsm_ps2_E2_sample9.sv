module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg done
);

// Define states
parameter IDLE = 2'b00;
parameter FIRST_BYTE = 2'b01;
parameter SECOND_BYTE = 2'b10;
parameter THIRD_BYTE = 2'b11;

// Define signals
reg [1:0] state, next_state;

// Sequential logic for state transition
always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
    done <= 0;
  end else begin
    state <= next_state;
  end
end

// Combinational logic for next state determination
always @* begin
  next_state = state; // Default next state to current state

  case (state)
    IDLE: begin
      if (in[3] == 1) begin
        next_state = FIRST_BYTE;
        done <= 0;
      end
    end

    FIRST_BYTE: begin
      if (in[3] == 0) begin
        next_state = IDLE; // Start over if in[3] is not 1
      end else begin
        next_state = SECOND_BYTE;
      end
    end

    SECOND_BYTE: begin
      if (in[3] == 0) begin
        next_state = IDLE; // Start over if in[3] is not 1
      end else begin
        next_state = THIRD_BYTE;
      end
    end

    THIRD_BYTE: begin
      next_state = IDLE; // Restart process after the third byte
      done <= 1; // Signal the completion of the message
    end
  endcase
end

endmodule
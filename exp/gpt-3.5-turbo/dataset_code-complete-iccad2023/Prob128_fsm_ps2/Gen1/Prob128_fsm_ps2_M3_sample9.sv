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
parameter DONE = 2'b11;

// Define signals
reg [1:0] state, next_state;

// Sequential logic
always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
    done <= 0;
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
        next_state = FIRST_BYTE;
      end
    end

    FIRST_BYTE: begin
      next_state = SECOND_BYTE;
    end

    SECOND_BYTE: begin
      next_state = (in[3] == 1) ? DONE : IDLE;
    end

    DONE: begin
      next_state = IDLE;
    end
  endcase
end

endmodule
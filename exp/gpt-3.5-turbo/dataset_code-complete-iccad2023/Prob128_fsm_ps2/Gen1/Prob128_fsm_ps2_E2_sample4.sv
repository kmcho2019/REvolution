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

// Define signals
reg [1:0] state, next_state;

// Sequential logic
always @(posedge clk or posedge reset) begin
  if (reset)
    state <= IDLE;
  else
    state <= next_state;
end

// Combinational logic
always @* begin
  next_state = state;

  case (state)
    IDLE: begin
      if (in[3] == 1)
        next_state = BYTE1;
    end

    BYTE1: begin
      if (in[3] == 0)
        next_state = IDLE;
      else
        next_state = BYTE2;
    end

    BYTE2: begin
      if (in[3] == 0)
        next_state = IDLE;
      else
        next_state = DONE;
    end

    DONE: begin
      next_state = IDLE;
      done = 1;
    end
  endcase
end

endmodule
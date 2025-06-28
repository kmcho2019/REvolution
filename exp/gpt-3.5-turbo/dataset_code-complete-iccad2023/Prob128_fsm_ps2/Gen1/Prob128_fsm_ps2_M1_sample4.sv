module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg done
);

// 4 states
parameter IDLE = 2'b00;
parameter BYTE1 = 2'b01;
parameter BYTE2 = 2'b10;
parameter DONE = 2'b11;

// Define state register
reg [1:0] state, next_state;
reg [1:0] byte_count;

// Synchronous reset
always @(posedge clk) begin
  if (reset) begin
    state <= IDLE;
    byte_count <= 2'b00;
  end
  else begin
    state <= next_state;
    byte_count <= (state == DONE) ? 2'b00 : byte_count + 1;
  end
end

// Next state logic and output
always @* begin
  case(state)
    IDLE: begin
      if (in[3] == 1)
        next_state = BYTE1;
      else
        next_state = IDLE;
      done = 0;
    end
    BYTE1: begin
      if (in[3] == 0)
        next_state = IDLE;
      else
        next_state = BYTE2;
      done = 0;
    end
    BYTE2: begin
      if (in[3] == 0)
        next_state = IDLE;
      else if (byte_count == 1)
        next_state = DONE;
      else
        next_state = BYTE2;
      done = 0;
    end
    DONE: begin
      next_state = IDLE;
      done = 1;
    end
    default: begin
      next_state = IDLE;
      done = 0;
    end
  endcase
end

endmodule
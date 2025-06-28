module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg done
);

// 3 states and count variable
parameter IDLE = 2'b00;
parameter RECEIVING = 2'b01;
parameter DONE = 2'b10;
reg [1:0] state, next_state;
reg [1:0] count;

// Synchronous reset
always @(posedge clk) begin
  if (reset)
    state <= IDLE;
  else
    state <= next_state;
end

// Next state logic and output
always @* begin
  case(state)
    IDLE: begin
      if (in[3] == 1) begin
        next_state = RECEIVING;
        count <= 0;
      end
      else
        next_state = IDLE;
      done = 0;
    end
    RECEIVING: begin
      if (count == 1 && in[3] == 1) begin
        next_state = DONE;
        count <= 0;
        done = 1;
      end
      else if (count == 2)
        next_state = IDLE;
      else begin
        next_state = RECEIVING;
        count <= count + 1;
      end
    end
    DONE: begin
      next_state = IDLE;
      done = 0;
    end
    default: begin
      next_state = IDLE;
      done = 0;
    end
  endcase
end

endmodule
module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg done
);

// States
parameter IDLE = 2'b00;
parameter FIRST_BYTE = 2'b01;
parameter SECOND_BYTE = 2'b10;
parameter THIRD_BYTE = 2'b11;

// State register
reg [1:0] state, next_state;

always @ (posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
    done <= 0;
  end
  else begin
    state <= next_state;
    done <= 0;
  end
end

// Next state logic
always @* begin
  case (state)
    IDLE: begin
      if (in[3] == 1)
        next_state = FIRST_BYTE;
      else
        next_state = IDLE;
    end
    FIRST_BYTE: begin
      next_state = SECOND_BYTE;
    end
    SECOND_BYTE: begin
      next_state = THIRD_BYTE;
    end
    THIRD_BYTE: begin
      next_state = IDLE;
      done = 1;
    end
    default: next_state = IDLE;
  endcase
end

endmodule
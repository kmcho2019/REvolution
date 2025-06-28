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
parameter CHECK_DONE = 2'b11;

// Define signals
reg [1:0] state;
reg [1:0] next_state;
reg [2:0] byte_count;

// State transition and outputs
always @(posedge clk or posedge reset) begin
  if (reset)
    state <= IDLE;
  else
    state <= next_state;
end

always @* begin
  case(state)
    IDLE: begin
      if (in[3] == 1) begin
        next_state = BYTE1;
        byte_count <= 1;
      end
      else begin
        next_state = IDLE;
        byte_count <= 0;
      end
    end
    BYTE1: begin
      next_state = BYTE2;
      byte_count <= byte_count + 1;
    end
    BYTE2: begin
      if (byte_count == 2)
        next_state = CHECK_DONE;
      else
        next_state = BYTE1;
      byte_count <= byte_count + 1;
    end
    CHECK_DONE: begin
      if (in[3] == 1)
        done = 1;
      else
        done = 0;
      next_state = IDLE;
      byte_count <= 0;
    end
    default: begin
      next_state = IDLE;
      byte_count <= 0;
    end
  endcase
end

endmodule
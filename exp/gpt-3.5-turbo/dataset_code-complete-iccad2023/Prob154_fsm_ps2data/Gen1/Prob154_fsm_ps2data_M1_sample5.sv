module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);

// Define FSM states
parameter IDLE = 2'b00;
parameter CHECK_FIRST_BYTE = 2'b01;
parameter CAPTURE_SECOND_BYTE = 2'b10;
parameter CAPTURE_THIRD_BYTE = 2'b11;

// Define signals
reg [1:0] state;
reg [7:0] byte1, byte2, byte3;

// FSM state update
always @(posedge clk or posedge reset) begin
  if (reset)
    state <= IDLE;
  else
    state <= next_state;
end

// FSM state logic
always @* begin
  done = 0;
  out_bytes = 24'hxxxxxx;
  next_state = state;

  case (state)
    IDLE:
      if (in[3])
        next_state = CHECK_FIRST_BYTE;
    CHECK_FIRST_BYTE:
      begin
        byte1 = in;
        if (in[3])
          next_state = CAPTURE_SECOND_BYTE;
        else
          next_state = IDLE;
      end
    CAPTURE_SECOND_BYTE:
      begin
        byte2 = in;
        if (in[3])
          next_state = CAPTURE_THIRD_BYTE;
        else
          next_state = IDLE;
      end
    CAPTURE_THIRD_BYTE:
      begin
        byte3 = in;
        out_bytes = {byte1, byte2, byte3};
        done = 1;
        next_state = IDLE;
      end
  endcase
end

endmodule
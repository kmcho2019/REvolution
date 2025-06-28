module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

// Define states for the FSM
parameter IDLE = 2'b00;
parameter DETECTING_START = 2'b01;
parameter DETECTING_COMPLETE = 2'b10;

reg [1:0] state = IDLE;
reg [2:0] bits_buffer = 3'b0;

always @(posedge clk) begin
  if (reset) begin
    state <= IDLE;
    start_shifting <= 0;
    bits_buffer <= 3'b0;
  end
  else begin
    case (state)
      IDLE:
        begin
          bits_buffer <= {bits_buffer[1:0], data};
          if (bits_buffer == 3'b110)
            state <= DETECTING_START;
        end
      DETECTING_START:
        begin
          bits_buffer <= {bits_buffer[1:0], data};
          if (bits_buffer == 3'b1101) begin
            state <= DETECTING_COMPLETE;
            start_shifting <= 1;
          end
          else if (bits_buffer != 3'b110)
            state <= IDLE;
        end
      DETECTING_COMPLETE:
        begin
          if (bits_buffer != 3'b1101)
            state <= IDLE;
        end
      default: state <= IDLE;
    endcase
  end
end

endmodule
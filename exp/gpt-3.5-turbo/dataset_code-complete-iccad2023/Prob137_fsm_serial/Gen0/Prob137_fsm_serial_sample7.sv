module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

// Define the states
parameter IDLE = 2'b00, RECEIVE = 2'b01, STOP = 2'b10, WAIT = 2'b11;
reg [1:0] state, next_state;

// Internal signals
reg [2:0] count;
reg expected_stop_bit;

// FSM
always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
    count <= 3'b0;
    expected_stop_bit <= 1'b1;
    done <= 1'b0;

  end else begin
    state <= next_state;
    if (state == IDLE) begin
      if (in == 1'b0) begin
        next_state <= RECEIVE;
        count <= 3'b0;
      end else begin
        next_state <= IDLE;
      end
    end else if (state == RECEIVE) begin
      if (count < 3'b111) begin
        next_state <= RECEIVE;
        count <= count + 1;
      end else begin
        next_state <= STOP;
      end
    end else if (state == STOP) begin
      if (in == expected_stop_bit) begin
        next_state <= WAIT;
        expected_stop_bit <= 1'b1;
      end else begin
        next_state <= IDLE;
      end
    end else begin // WAIT
      if (in == 1'b1) begin
        next_state <= IDLE;
        done <= 1'b1;
      end else begin
        next_state <= WAIT;
      end
    end
  end
end

endmodule
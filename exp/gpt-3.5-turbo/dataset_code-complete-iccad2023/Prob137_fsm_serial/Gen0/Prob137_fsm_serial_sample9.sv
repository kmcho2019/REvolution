module TopModule (
  input clk,
  input in,
  input reset,
  output done
);

// Define the states
typedef enum logic [2:0] {
  IDLE,
  RECEIVE,
  STOP,
  WAIT
} state_type;

// Registers
reg [2:0] state, next_state;
reg [2:0] data_counter;
reg done;

// Constants
localparam START_BIT = 3'b000;
localparam STOP_BIT = 3'b001;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
    data_counter <= 3'b0;
    done <= 1'b0;
  end 
  else begin
    state <= next_state;
    data_counter <= (state == RECEIVE) ? data_counter + 1 : 3'b0;
    done <= (state == STOP && in) ? 1'b1 : 1'b0;
  end
end

always @* begin
  next_state = state;
  
  case (state)
    IDLE: begin
      if (in == 1'b0)
        next_state = RECEIVE;
    end
    RECEIVE: begin
      if (data_counter == 3'b111)
        next_state = STOP;
    end
    STOP: begin
      if (in == 1'b0)
        next_state = IDLE;
      else if (in == 1'b1)
        next_state = WAIT;
    end
    WAIT: begin
      if (in == 1'b0)
        next_state = IDLE;
    end
  endcase
end

endmodule
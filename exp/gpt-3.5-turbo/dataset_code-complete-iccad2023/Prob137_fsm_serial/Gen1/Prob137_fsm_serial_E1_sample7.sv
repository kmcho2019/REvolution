module TopModule (
  input clk,
  input in,
  input reset,
  output done
);

  // Define states
  parameter IDLE = 2'b00;
  parameter START_BIT = 2'b01;
  parameter DATA_BITS_0to7 = 2'b10;
  parameter STOP_BIT = 2'b11;
  
  // Define internal signals
  reg [1:0] state, next_state;
  reg [7:0] data;

  // FSM
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      data <= 8'b0;
    end else begin
      state <= next_state;
    end
  end

  // State transitions and data processing based on input and state
  always @(*) begin
    next_state = state;
    
    case (state)
      IDLE: begin
        if (in == 1'b0) begin
          next_state = START_BIT;
        end
      end
      START_BIT: begin
        next_state = DATA_BITS_0to7;
        data <= {data[6:0], in};
      end
      DATA_BITS_0to7: begin
        data <= {data[6:0], in};
        if (data == 8'b00000001) begin
          next_state = STOP_BIT;
        end
      end
      STOP_BIT: begin
        if (in == 1'b1) begin
          next_state = IDLE; // Reset to IDLE once a new byte can start
        end else begin
          next_state = DATA_BITS_0to7;
        end
      end
    endcase
  end

  // Output "done" signal when a complete byte has been received
  assign done = (state == STOP_BIT);

endmodule
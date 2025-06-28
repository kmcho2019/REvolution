module TopModule (
  input clk,
  input in,
  input reset,
  output reg [7:0] out_byte,
  output reg done
);
  
  // Define states
  parameter IDLE = 2'b00;
  parameter START_BIT = 2'b01;
  parameter DATA_BITS = 2'b10;
  parameter STOP_BIT = 2'b11;
  
  // Define registers for state and count
  reg [1:0] state, next_state;
  reg [2:0] count; // Represents the number of bits received
  
  // State transition logic
  always @ (posedge clk or posedge reset) begin
    if (reset == 1'b1) begin
      state <= IDLE;
      count <= 3'b0; // Reset count to 0
    end
    else begin
      state <= next_state;
      count <= count + 1;
    end
  end
  
  // Determine next state based on current state and input
  always @* begin
    next_state = state;
    case (state)
      IDLE: if (in == 1'b0) next_state = START_BIT;
      START_BIT: next_state = DATA_BITS;
      DATA_BITS: if (count == 8) next_state = STOP_BIT;
                else next_state = DATA_BITS;
      STOP_BIT: if (in == 1'b1 && count == 9) begin
                  out_byte <= {in, out_byte[7:1]}; // Shift in the received bit
                  done <= 1'b1;
                  next_state = IDLE;
                end
                else next_state = STOP_BIT;
      default: next_state = IDLE;
    endcase
  end
  
endmodule
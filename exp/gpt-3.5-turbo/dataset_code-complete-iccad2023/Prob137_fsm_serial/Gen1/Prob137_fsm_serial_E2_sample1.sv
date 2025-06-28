module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

  // Define states
  parameter IDLE = 3'b000;
  parameter START_BIT = 3'b001;
  parameter DATA_BITS_0to7 = 3'b010;
  parameter STOP_BIT = 3'b011;
  parameter WAIT_FOR_IDLE = 3'b100;

  // Internal signals
  reg [2:0] state, next_state;
  reg [7:0] data;
  reg [2:0] shift_reg;

  // FSM
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      shift_reg <= 3'b0;
      data <= 8'b0;
      done <= 0;
    end else begin
      state <= next_state;
    end
  end

  // State transitions and data processing
  always @(*) begin
    next_state = state;
    
    case (state)
      IDLE: begin
        if (in == 1'b0) begin
          next_state = START_BIT;
          shift_reg <= {shift_reg[1:0], in};
        end
      end
      START_BIT: begin
        shift_reg <= {shift_reg[1:0], in};
        if (shift_reg == 3'b000) begin
          next_state = DATA_BITS_0to7;
          shift_reg <= 3'b0;
        end
      end
      DATA_BITS_0to7: begin
        shift_reg <= {shift_reg[1:0], in};
        data <= {data[6:0], shift_reg[0]};
        if (shift_reg == 3'b000) begin
          next_state = STOP_BIT;
          shift_reg <= 3'b0;
        end
      end
      STOP_BIT: begin
        shift_reg <= {shift_reg[1:0], in};
        if (shift_reg == 3'b001) begin
          next_state = WAIT_FOR_IDLE;
          shift_reg <= 3'b0;
        end else if (shift_reg == 3'b000) begin
          next_state = DATA_BITS_0to7;
          shift_reg <= 3'b0;
        end
      end
      WAIT_FOR_IDLE: begin
        if (in == 1'b1) begin
          next_state = IDLE; // Reset to IDLE once a new byte can start
          done <= 1;
        end
      end
    endcase
  end

endmodule
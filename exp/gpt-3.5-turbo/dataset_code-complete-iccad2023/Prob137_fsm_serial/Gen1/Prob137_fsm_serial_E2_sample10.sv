module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

// Parameters
parameter IDLE = 2'b00, START_BIT = 2'b01, DATA_BITS = 2'b10, STOP_BIT = 2'b11;
parameter BYTE_SIZE = 8;

// Registers
reg [7:0] shift_reg = 8'b11111111; // Initialized to idle state
reg [2:0] state = IDLE;
reg [3:0] bits_received = 0;

// FSM
always@(posedge clk or posedge reset) begin
  if(reset) begin
    state <= IDLE;
    shift_reg <= 8'b11111111;
    bits_received <= 0;
    done <= 0;
  end
  else begin
    case(state)
      IDLE: begin
        if(in == 1'b0) begin
          shift_reg <= {shift_reg[6:0], in};
          state <= START_BIT;
          bits_received <= 0;
        end
      end
      START_BIT: begin
        if(bits_received < BYTE_SIZE) begin
          shift_reg <= {shift_reg[6:0], in};
          bits_received <= bits_received + 1;
          state <= DATA_BITS;
        end
        else if(in == 1'b1) begin
          shift_reg <= {shift_reg[6:0], in};
          state <= STOP_BIT;
        end
        else begin
          shift_reg <= {shift_reg[6:0], in};
          state <= IDLE;
        end
      end
      DATA_BITS: begin
        if(bits_received < BYTE_SIZE) begin
          shift_reg <= {shift_reg[6:0], in};
          bits_received <= bits_received + 1;
          state <= DATA_BITS;
        end
      end
      STOP_BIT: begin
        if(in == 1'b1) begin
          shift_reg <= {shift_reg[6:0], in};
          state <= IDLE;
          done <= 1;
        end
        else begin
          shift_reg <= {shift_reg[6:0], in};
          state <= STOP_BIT;
        end
      end
      default: state <= IDLE;
    endcase
  end
end

endmodule
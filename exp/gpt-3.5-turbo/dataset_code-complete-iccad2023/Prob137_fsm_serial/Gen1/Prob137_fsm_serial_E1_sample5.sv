module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

// Define the states
parameter [2:0] IDLE = 3'b000, WAIT_START_BIT = 3'b001, RECEIVE_BITS = 3'b010, WAIT_STOP_BIT = 3'b011;
reg [2:0] state, next_state;

// Internal signals
reg [2:0] shift_reg;
reg start_bit_detected, stop_bit_detected;

// FSM
always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
    shift_reg <= 3'b000;
    start_bit_detected <= 1'b0;
    stop_bit_detected <= 1'b0;
    done <= 1'b0;
  end 
  else begin
      case(state)
        IDLE: begin
          if(in == 1'b0) begin
            next_state <= WAIT_START_BIT;
            shift_reg <= {shift_reg[1:0], in};
          end else begin
            next_state <= IDLE;
            shift_reg <= {shift_reg[1:0], in};
          end
        end

        WAIT_START_BIT: begin
          if(shift_reg == 3'b100) begin
            next_state <= RECEIVE_BITS;
            shift_reg <= 3'b000;
          end else begin
            next_state <= WAIT_START_BIT;
            shift_reg <= {shift_reg[1:0], in};
          end
        end

        RECEIVE_BITS: begin
            if(shift_reg == 3'b111) begin
              next_state <= WAIT_STOP_BIT;
              shift_reg <= 3'b000;
            end else begin
              next_state <= RECEIVE_BITS;
              shift_reg <= {shift_reg[1:0], in};
            end
        end

        WAIT_STOP_BIT: begin
          if(in == 1'b1) begin
            next_state <= IDLE;
            done <= 1'b1;
          end else begin
            next_state <= WAIT_STOP_BIT;
          end
        end

        default: begin
          next_state <= IDLE;
          shift_reg <= 3'b000;
        end
      endcase
  end

  state <= next_state;
end

endmodule
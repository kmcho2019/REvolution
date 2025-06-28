module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

// States
typedef enum logic [1:0] {
  IDLE,
  RECEIVING
} state_t;

// Registers
reg [7:0] shift_reg;
reg [1:0] state, next_state;

// FSM
always_ff @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
    done <= 0;
    shift_reg <= 8'b0;
  end
  else begin
    state <= next_state;
    case (state)
      IDLE: begin
        if (in == 1'b0) begin
          next_state = RECEIVING;
          shift_reg <= {shift_reg[6:0], in};
        end
        else begin
          next_state = IDLE;
        end
      end
      RECEIVING: begin
        shift_reg <= {shift_reg[6:0], in};
        if (shift_reg[7] && !shift_reg[0]) begin
          done <= 1;
          next_state = IDLE;
          shift_reg <= 8'b0;
        end
        else begin
          next_state = RECEIVING;
        end
      end
      default: next_state = IDLE;
    endcase
  end
end

endmodule
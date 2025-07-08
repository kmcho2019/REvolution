module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output done
);

  // Define states
  typedef enum logic [1:0] {
    IDLE,
    BYTE2,
    BYTE3
  } state_t;

  // State register
  state_t state, next_state;

  // State transition logic
  always_ff @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
    end else begin
      state <= next_state;
    end
  end

  // Next state logic
  always_comb begin
    case (state)
      IDLE: begin
        if (in[3]) begin
          next_state = BYTE2;
        end else begin
          next_state = IDLE;
        end
      end
      BYTE2: begin
        next_state = BYTE3;
      end
      BYTE3: begin
        next_state = IDLE;
      end
      default: begin
        next_state = IDLE;
      end
    endcase
  end

  // Output logic
  assign done = (state == BYTE3);

endmodule
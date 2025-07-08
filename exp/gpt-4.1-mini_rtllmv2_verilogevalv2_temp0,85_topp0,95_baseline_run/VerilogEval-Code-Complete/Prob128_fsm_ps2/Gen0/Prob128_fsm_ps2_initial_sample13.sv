module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg done
);

  typedef enum reg [1:0] {
    IDLE  = 2'b00,
    BYTE2 = 2'b01,
    BYTE3 = 2'b10
  } state_t;

  reg [1:0] state, next_state;

  // State transition logic
  always @(*) begin
    done = 1'b0;
    case(state)
      IDLE: begin
        if (in[3] == 1'b1)
          next_state = BYTE2;
        else
          next_state = IDLE;
      end

      BYTE2: begin
        next_state = BYTE3;
      end

      BYTE3: begin
        next_state = IDLE;
        done = 1'b1; // signal done after third byte received
      end

      default: begin
        next_state = IDLE;
      end
    endcase
  end

  // State register update with synchronous reset
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      done <= 1'b0;
    end else begin
      state <= next_state;
    end
  end

endmodule
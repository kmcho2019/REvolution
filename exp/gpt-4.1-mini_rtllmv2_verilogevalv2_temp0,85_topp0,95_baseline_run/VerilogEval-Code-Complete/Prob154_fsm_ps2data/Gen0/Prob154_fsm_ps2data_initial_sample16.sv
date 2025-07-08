module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);

  typedef enum logic [1:0] {
    IDLE  = 2'd0,
    BYTE1 = 2'd1,
    BYTE2 = 2'd2,
    BYTE3 = 2'd3
  } state_t;

  state_t state, next_state;
  reg [7:0] byte1, byte2, byte3;

  // State transition logic
  always @(*) begin
    done = 1'b0;
    next_state = state;
    case(state)
      IDLE: begin
        if (in[3] == 1'b1)
          next_state = BYTE1;
      end
      BYTE1: next_state = BYTE2;
      BYTE2: next_state = BYTE3;
      BYTE3: begin
        next_state = IDLE;
        done = 1'b1;
      end
      default: next_state = IDLE;
    endcase
  end

  // State and data registers update
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      byte1 <= 8'd0;
      byte2 <= 8'd0;
      byte3 <= 8'd0;
      out_bytes <= 24'd0;
      done <= 1'b0;
    end else begin
      state <= next_state;
      case(next_state)
        BYTE1: byte1 <= in;
        BYTE2: byte2 <= in;
        BYTE3: begin
          byte3 <= in;
          out_bytes <= {byte1, byte2, in};
          done <= 1'b1;
        end
        default: done <= 1'b0;
      endcase
      // Clear done if not in BYTE3 state
      if (next_state != BYTE3)
        done <= 1'b0;
    end
  end

endmodule
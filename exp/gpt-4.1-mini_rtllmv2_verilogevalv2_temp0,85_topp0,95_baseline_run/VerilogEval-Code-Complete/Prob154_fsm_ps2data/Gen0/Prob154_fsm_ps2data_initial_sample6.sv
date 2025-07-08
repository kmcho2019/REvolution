module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);
  // State encoding
  typedef enum reg [1:0] {
    IDLE = 2'b00,
    BYTE2 = 2'b01,
    BYTE3 = 2'b10
  } state_t;

  state_t state, next_state;

  reg [7:0] byte1, byte2, byte3;

  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      done <= 0;
      out_bytes <= 24'bx;
      byte1 <= 8'b0;
      byte2 <= 8'b0;
      byte3 <= 8'b0;
    end else begin
      done <= 0; // default done deasserted every cycle
      state <= next_state;
      case(state)
        IDLE: begin
          if (in[3]) begin
            // start of message found
            byte1 <= in;
          end
        end
        BYTE2: begin
          byte2 <= in;
        end
        BYTE3: begin
          byte3 <= in;
          done <= 1;
          out_bytes <= {byte1, byte2, in};
        end
        default: begin
          // Should never get here
          done <= 0;
        end
      endcase
    end
  end

  always @(*) begin
    next_state = state;
    case(state)
      IDLE: begin
        if (in[3])
          next_state = BYTE2;
      end
      BYTE2: begin
        next_state = BYTE3;
      end
      BYTE3: begin
        next_state = IDLE;
      end
      default: next_state = IDLE;
    endcase
  end

endmodule
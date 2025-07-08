module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);

  // FSM states
  typedef enum reg [1:0] {
    IDLE  = 2'b00,
    BYTE2 = 2'b01,
    BYTE3 = 2'b10
  } state_t;

  reg [7:0] byte1, byte2, byte3;
  reg [1:0] state, next_state;

  // State register and output logic
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      byte1 <= 8'b0;
      byte2 <= 8'b0;
      byte3 <= 8'b0;
      out_bytes <= 24'b0;
      done <= 1'b0;
    end else begin
      state <= next_state;
      done <= 1'b0; // default done low, set high only on BYTE3 state transition

      case(state)
        IDLE: begin
          if (in[3]) begin
            byte1 <= in;
            // stay until next state transition
          end
        end
        BYTE2: begin
          byte2 <= in;
        end
        BYTE3: begin
          byte3 <= in;
          // done asserted after byte3 received
          out_bytes <= {byte1, byte2, in};
          done <= 1'b1;
        end
      endcase
    end
  end

  // Next state logic
  always @(*) begin
    case(state)
      IDLE: begin
        if (in[3])
          next_state = BYTE2;
        else
          next_state = IDLE;
      end
      BYTE2: next_state = BYTE3;
      BYTE3: next_state = IDLE;
      default: next_state = IDLE;
    endcase
  end

endmodule
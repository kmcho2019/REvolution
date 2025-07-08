module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);
  // State encoding
  localparam IDLE  = 2'b00,
             BYTE2 = 2'b01,
             BYTE3 = 2'b10;

  reg [1:0] state, next_state;

  // Registers to hold message bytes
  reg [7:0] byte1, byte2, byte3;

  // State register with synchronous active-high reset
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
      done <= 1'b0; // default no done

      case(state)
        IDLE: begin
          if (in[3]) begin
            byte1 <= in;
            // Wait for next byte
          end
        end
        BYTE2: begin
          byte2 <= in;
        end
        BYTE3: begin
          byte3 <= in;
          // done asserted next cycle
        end
      endcase

      // Output assignment and done signal in BYTE3 state transition
      if (state == BYTE3) begin
        out_bytes <= {byte1, byte2, in};
        done <= 1'b1;
      end
    end
  end

  // Next state logic combinational
  always @(*) begin
    case(state)
      IDLE: next_state = in[3] ? BYTE2 : IDLE;
      BYTE2: next_state = BYTE3;
      BYTE3: next_state = IDLE;
      default: next_state = IDLE;
    endcase
  end

endmodule
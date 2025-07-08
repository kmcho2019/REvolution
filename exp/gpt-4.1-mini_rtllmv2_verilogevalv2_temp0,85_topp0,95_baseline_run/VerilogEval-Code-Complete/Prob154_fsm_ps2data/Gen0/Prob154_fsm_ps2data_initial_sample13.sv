module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);

  // State encoding
  typedef enum logic [1:0] {
    IDLE = 2'b00,
    BYTE1 = 2'b01,
    BYTE2 = 2'b10,
    BYTE3 = 2'b11
  } state_t;

  state_t state, next_state;

  // Registers to hold the 3 bytes
  reg [7:0] byte1, byte2, byte3;

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

      // Default done low unless at BYTE3 done cycle
      done <= 1'b0;

      case (state)
        IDLE: begin
          if (in[3]) begin
            byte1 <= in;
          end
        end
        BYTE1: begin
          byte2 <= in;
        end
        BYTE2: begin
          byte3 <= in;
        end
        BYTE3: begin
          // Output the 3-byte message, done asserted this cycle
          out_bytes <= {byte1, byte2, byte3};
          done <= 1'b1;
        end
      endcase
    end
  end

  // Next state logic
  always @(*) begin
    case(state)
      IDLE: begin
        if (in[3]) next_state = BYTE1;
        else next_state = IDLE;
      end
      BYTE1: next_state = BYTE2;
      BYTE2: next_state = BYTE3;
      BYTE3: next_state = IDLE;
      default: next_state = IDLE;
    endcase
  end

endmodule
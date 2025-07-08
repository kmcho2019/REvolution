module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);

  // State encoding
  localparam IDLE  = 2'd0;
  localparam BYTE1 = 2'd1;
  localparam BYTE2 = 2'd2;
  localparam BYTE3 = 2'd3;

  reg [1:0] state, next_state;
  reg [7:0] byte1, byte2, byte3;

  // State register with synchronous reset
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

      // On done cycle, output valid message
      if (state == BYTE3 && next_state == IDLE) begin
        // done is asserted in next cycle after third byte
        // so output must be valid now for done
        out_bytes <= {byte1, byte2, byte3};
        done <= 1'b1;
      end else begin
        done <= 1'b0;
      end

      // Capture bytes at each state
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
        default: begin
          // no update
        end
      endcase
    end
  end

  // Next state logic
  always @(*) begin
    case (state)
      IDLE:
        if (in[3]) next_state = BYTE1;
        else next_state = IDLE;
      BYTE1:
        next_state = BYTE2;
      BYTE2:
        next_state = BYTE3;
      BYTE3:
        next_state = IDLE;
      default:
        next_state = IDLE;
    endcase
  end

endmodule
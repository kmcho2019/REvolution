module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);

  // State encoding
  localparam IDLE = 2'd0;
  localparam BYTE1 = 2'd1;
  localparam BYTE2 = 2'd2;
  localparam BYTE3 = 2'd3;

  reg [1:0] state, next_state;

  reg [7:0] byte1, byte2, byte3;

  // FSM next state logic and output logic
  always @(*) begin
    done = 0;
    next_state = state;
    case(state)
      IDLE: begin
        if (in[3])        // start of message detected
          next_state = BYTE1;
      end

      BYTE1: begin
        next_state = BYTE2;
      end

      BYTE2: begin
        next_state = BYTE3;
      end

      BYTE3: begin
        done = 1;
        next_state = IDLE;
      end
    endcase
  end

  // State register and output registers, synchronous reset
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      byte1 <= 8'h00;
      byte2 <= 8'h00;
      byte3 <= 8'h00;
      out_bytes <= 24'hx;
      done <= 0;
    end else begin
      state <= next_state;
      case (state)
        IDLE: begin
          if (in[3]) byte1 <= in;
        end
        BYTE1: begin
          byte2 <= in;
        end
        BYTE2: begin
          byte3 <= in;
        end
        BYTE3: begin
          // done is asserted combinationally, so this is the cycle after receiving the third byte
          out_bytes <= {byte1, byte2, byte3};
        end
      endcase
    end
  end

endmodule
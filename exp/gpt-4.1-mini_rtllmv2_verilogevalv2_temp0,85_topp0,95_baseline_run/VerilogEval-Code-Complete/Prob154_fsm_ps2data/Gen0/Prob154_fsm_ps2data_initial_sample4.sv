module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);

  // State encoding
  localparam IDLE  = 2'd0;
  localparam BYTE2 = 2'd1;
  localparam BYTE3 = 2'd2;

  reg [1:0] state, next_state;
  reg [7:0] byte1, byte2, byte3;

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

      done <= 1'b0; // default no done signal

      case(state)
        IDLE: begin
          // Waiting for first byte with in[3] = 1
          if (in[3]) begin
            byte1 <= in;
            // next state change below
          end
        end
        BYTE2: begin
          byte2 <= in;
        end
        BYTE3: begin
          byte3 <= in;
          // output the message and assert done
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
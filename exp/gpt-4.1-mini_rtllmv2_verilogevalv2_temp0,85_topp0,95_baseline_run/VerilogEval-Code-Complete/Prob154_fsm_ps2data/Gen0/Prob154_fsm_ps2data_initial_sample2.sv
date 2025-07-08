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

  // State transition logic
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      done <= 1'b0;
    end else begin
      state <= next_state;
      // done asserted only one cycle at BYTE3 state completion
      done <= (state == BYTE3);
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

  // Output and byte registers update
  always @(posedge clk) begin
    if (reset) begin
      byte1 <= 8'd0;
      byte2 <= 8'd0;
      byte3 <= 8'd0;
      out_bytes <= 24'd0;
    end else begin
      case(state)
        IDLE: begin
          // no byte stored
        end
        BYTE1: begin
          byte1 <= in;
        end
        BYTE2: begin
          byte2 <= in;
        end
        BYTE3: begin
          byte3 <= in;
          // Output concatenation on done cycle (next cycle done will be high)
          out_bytes <= {byte1, byte2, in};
        end
      endcase
    end
  end

endmodule
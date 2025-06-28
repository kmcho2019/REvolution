module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);

  // Define states
  parameter WAIT_FOR_START = 2'b00;
  parameter BYTE2 = 2'b01;
  parameter BYTE3 = 2'b10;

  // Declare state and next_state signals
  reg [1:0] state, next_state;
  reg [1:0] byte_cnt;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= WAIT_FOR_START;
      byte_cnt <= 0;
      out_bytes <= 0;
      done <= 0;
    end else begin
      state <= next_state;
      case(state)
        WAIT_FOR_START:
          if (in[3] == 1) begin
            next_state = BYTE2;
            byte_cnt <= 0;
          end else begin
            next_state = WAIT_FOR_START;
          end
        BYTE2:
          if (byte_cnt == 1) begin
            next_state = BYTE3;
          end else begin
            next_state = BYTE2;
          end
        BYTE3:
          next_state = WAIT_FOR_START;
      endcase
    end
  end

  always @* begin
    case(state)
      WAIT_FOR_START:
        if (in[3] == 1) begin
          byte_cnt <= 0;
        end
      BYTE2:
        if (byte_cnt == 0) begin
          out_bytes [23:16] <= in;
          byte_cnt <= 1;
        end
        else begin
          out_bytes [15:8] <= in;
        end
      BYTE3:
        out_bytes [7:0] <= in;
        done <= 1;
    endcase
  end

endmodule
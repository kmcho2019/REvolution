module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);

  // Define states
  parameter IDLE = 2'b00;
  parameter FIRST_BYTE = 2'b01;
  parameter SECOND_BYTE = 2'b10;
  parameter THIRD_BYTE = 2'b11;
  reg [1:0] state, next_state;

  // Define registers to store received bytes
  reg [7:0] byte1, byte2, byte3;

  always @ (posedge clk) begin
    if (reset) begin
      state <= IDLE;
      done <= 0;
    end else begin
      state <= next_state;
      case (state)
        IDLE: begin
          if (in[3] == 1) begin
            byte1 <= in;
            next_state <= FIRST_BYTE;
          end else begin
            next_state <= IDLE;
          end
        end
        FIRST_BYTE: begin
          byte2 <= in;
          next_state <= SECOND_BYTE;
        end
        SECOND_BYTE: begin
          byte3 <= in;
          next_state <= THIRD_BYTE;
        end
        THIRD_BYTE: begin
          out_bytes <= {byte1, byte2, byte3};
          done <= 1;
          next_state <= IDLE;
        end
      endcase
    end
  end

endmodule
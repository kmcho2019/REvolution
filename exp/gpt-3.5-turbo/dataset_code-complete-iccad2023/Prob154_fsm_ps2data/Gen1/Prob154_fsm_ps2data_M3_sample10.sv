module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);

  // Define states
  parameter IDLE = 2'b00, FIRST_BYTE = 2'b01, SECOND_BYTE = 2'b10, THIRD_BYTE = 2'b11;
  reg [1:0] state;
  reg [7:0] byte1, byte2, byte3;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      done <= 0;
      out_bytes <= 24'b0;
    end else begin
      case(state)
        IDLE: begin
          if (in[3] == 1) begin
            byte1 <= in;
            state <= FIRST_BYTE;
          end
        end
        FIRST_BYTE: begin
          byte2 <= in;
          state <= SECOND_BYTE;
        end
        SECOND_BYTE: begin
          byte3 <= in;
          state <= THIRD_BYTE;
        end
        THIRD_BYTE: begin
          out_bytes <= {byte1, byte2, byte3};
          done <= 1;
          state <= IDLE;
        end
      endcase
    end
  end

endmodule
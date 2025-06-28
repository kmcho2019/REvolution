module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);

  reg [7:0] byte1, byte2, byte3;
  reg [1:0] state;
  parameter IDLE = 2'b00, BYTE_1 = 2'b01, BYTE_2 = 2'b10;

  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      out_bytes <= 24'b0;
      done <= 0;
      byte1 <= 8'b0;
      byte2 <= 8'b0;
      byte3 <= 8'b0;
    end else begin
      case (state)
        IDLE: begin
          if (in[3] == 1) begin
            state <= BYTE_1;
            byte1 <= in;
          end
        end
        BYTE_1: begin
          if (in[3] == 0) begin
            state <= BYTE_2;
            byte2 <= in;
          end
        end
        BYTE_2: begin
          byte3 <= in;
          out_bytes <= {byte1, byte2, byte3};
          done <= 1;
          state <= IDLE;
        end
      endcase
    end
  end

endmodule
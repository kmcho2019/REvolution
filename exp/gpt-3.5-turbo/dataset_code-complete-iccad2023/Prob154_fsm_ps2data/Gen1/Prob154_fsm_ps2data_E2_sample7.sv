module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);

  // Define FSM states
  parameter IDLE = 2'b00;
  parameter CHECK_FIRST_BYTE = 2'b01;
  parameter CAPTURE_SECOND_BYTE = 2'b10;
  parameter CAPTURE_THIRD_BYTE = 2'b11;

  // Define signals
  reg [1:0] state;
  reg [7:0] byte1, byte2, byte3;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      byte1 <= 8'h00;
      byte2 <= 8'h00;
      byte3 <= 8'h00;
      done <= 0;
      out_bytes <= 24'hxxxxxx;
    end
    else begin
      case (state)
        IDLE: begin
          if (in[3] == 1)
            state <= CHECK_FIRST_BYTE;
        end
        CHECK_FIRST_BYTE: begin
          byte1 <= in;
          state <= CAPTURE_SECOND_BYTE;
        end
        CAPTURE_SECOND_BYTE: begin
          byte2 <= in;
          state <= CAPTURE_THIRD_BYTE;
        end
        CAPTURE_THIRD_BYTE: begin
          byte3 <= in;
          state <= IDLE;
          out_bytes <= {byte1, byte2, byte3};
          done <= 1;
        end
      endcase
    end
  end

endmodule
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

  // Define state register
  reg [1:0] state_reg, state_next;

  // Define byte registers
  reg [7:0] byte1_reg, byte2_reg, byte3_reg;

  // State transition and logic
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state_reg <= IDLE;
      byte1_reg <= 8'h00;
      byte2_reg <= 8'h00;
      byte3_reg <= 8'h00;
      done <= 0;
      out_bytes <= 24'hxxxxxx;
    end else begin
      // State transition logic
      state_reg <= state_next;
      case (state_reg)
        IDLE: begin
          if (in[3])
            state_next = CHECK_FIRST_BYTE;
          else
            state_next = IDLE;
        end
        CHECK_FIRST_BYTE: begin
          byte1_reg <= in;
          state_next = CAPTURE_SECOND_BYTE;
        end
        CAPTURE_SECOND_BYTE: begin
          byte2_reg <= in;
          state_next = CAPTURE_THIRD_BYTE;
        end
        CAPTURE_THIRD_BYTE: begin
          byte3_reg <= in;
          state_next = IDLE;
          out_bytes <= {byte1_reg, byte2_reg, byte3_reg};
          done <= 1;
        end
      endcase
    end
  end

endmodule
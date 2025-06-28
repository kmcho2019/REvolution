module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);

  // Declare state and shift register for byte storage
  reg [1:0] state;
  reg [7:0] shift_reg [2:0];

  // Define FSM states
  parameter IDLE = 2'b00, BYTE1 = 2'b01, BYTE2 = 2'b10, BYTE3 = 2'b11;

  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      out_bytes <= 24'h0;
      done <= 0;
      for (int i = 0; i < 3; i = i + 1)
        shift_reg[i] <= 8'h00;
    end else begin
      case (state)
        IDLE: begin
          if (in[3] == 1) begin
            state <= BYTE1;
            shift_reg[0] <= in;
          end
        end
        BYTE1: begin
          shift_reg[1] <= in;
          state <= in[3] ? BYTE1 : BYTE2;  // Stay in BYTE1 for the first byte until in[3] == 0
        end
        BYTE2: begin
          shift_reg[2] <= in;
          state <= in[3] ? BYTE1 : BYTE3;  // Transition to BYTE3 only if in[3] == 0
        end
        BYTE3: begin
          out_bytes <= {shift_reg[0], shift_reg[1], shift_reg[2]};
          done <= 1;
          state <= IDLE;
        end
      endcase
    end
  end

endmodule
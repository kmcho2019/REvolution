module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output [23:0] out_bytes,
  output reg done
);

  reg [1:0] state;
  reg [7:0] byte1, byte2, byte3;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= 2'b00; // IDLE state
      done <= 0;
    end
    else begin
      case (state)
        2'b00: begin // IDLE state
          if (in[3] == 1) begin
            byte1 <= in;
            state <= 2'b01; // Move to BYTE1 state
          end
        end
        2'b01: begin // BYTE1 state
          byte2 <= in;
          state <= 2'b10; // Move to BYTE2 state
        end
        2'b10: begin // BYTE2 state
          byte3 <= in;
          state <= 2'b11; // Move to BYTE3 state
        end
        2'b11: begin // BYTE3 state
          out_bytes <= {byte1, byte2, byte3};
          done <= 1;
          state <= 2'b00; // Move back to IDLE state
        end
      endcase
    end
  end

endmodule
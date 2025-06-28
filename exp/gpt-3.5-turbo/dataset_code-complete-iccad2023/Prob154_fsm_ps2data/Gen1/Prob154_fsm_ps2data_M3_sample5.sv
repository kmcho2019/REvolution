module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);

  reg [1:0] state;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= 2'b00; // IDLE state
      out_bytes <= 24'd0;
      done <= 0;
    end
    else begin
      case (state)
        2'b00: begin // IDLE state
          if (in[3] == 1) begin
            out_bytes[7:0] <= in;
            state <= 2'b01; // Move to MESSAGE state
          end
        end
        2'b01: begin // MESSAGE state
          out_bytes[15:8] <= in;
          state <= 2'b10; // Move to final state before resetting
        end
        2'b10: begin // Final state before reset
          out_bytes[23:16] <= in;
          done <= 1;
          state <= 2'b00; // Move back to IDLE state
        end
      endcase
    end
  end

endmodule
module TopModule (
  input clk,
  input in,
  input reset,
  output [7:0] out_byte,
  output reg done
);

  reg [2:0] state;
  reg [7:0] shift_reg;
  reg start_detected, stop_detected;
  
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= 3'b000;
      shift_reg <= 8'b0;
      start_detected <= 1'b0;
      stop_detected <= 1'b0;
      done <= 1'b0;
      out_byte <= 8'b0;
    end
    else begin
      case (state)
        3'b000: begin // Idle state
          if (in == 1'b0) begin
            shift_reg <= {in, shift_reg[7:1]};
            start_detected <= 1'b1;
            state <= 3'b001; // Transition to start bit detected state
          end
        end
        3'b001: begin // Data bit state
          shift_reg <= {in, shift_reg[7:1]};
          if (!start_detected) begin
            state <= 3'b000; // Roll back if start bit not detected
          end
          else if (shift_reg == 8'b01010101) begin // Stop bit detected
            out_byte <= shift_reg[6:0];
            stop_detected <= 1'b1;
            state <= 3'b010; // Transition to stop bit detected state
          end
        end
        3'b010: begin // Stop bit detected state
          if (stop_detected) begin
            done <= 1'b1; // Byte reception complete
            state <= 3'b000; // Transition back to idle state
            start_detected <= 1'b0;
            stop_detected <= 1'b0;
          end
        end
      endcase
    end
  end

endmodule
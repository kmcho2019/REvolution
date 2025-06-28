module TopModule (
  input clk,
  input in,
  input reset,
  output reg [7:0] out_byte,
  output reg done
);

  reg [2:0] state;
  reg [7:0] shift_reg;
  reg [2:0] bit_counter;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= 3'b000;
      shift_reg <= 8'b0;
      bit_counter <= 3'b000;
      out_byte <= 8'b0;
      done <= 1'b0;
    end
    else begin
      case (state)
        3'b000: begin // Idle state, waiting for start bit
          if (in == 1'b0) begin
            state <= 3'b001; // Transition to start bit detected state
            bit_counter <= 3'd0;
          end
        end
        3'b001: begin // Start bit detected, receive 8 data bits
          shift_reg <= {shift_reg[6:0], in};
          bit_counter <= bit_counter + 1;
          if (bit_counter == 7) begin
            state <= 3'b010; // Transition to stop bit expected state
          end
        end
        3'b010: begin // Stop bit expected
          if (in == 1'b1) begin
            out_byte <= shift_reg;
            done <= 1'b1;
            state <= 3'b000; // Transition to idle state
          end
          else if (in == 1'b0) begin
            state <= 3'b000; // Revert back to idle state if stop bit not found
          end
        end
      endcase
    end
  end

endmodule
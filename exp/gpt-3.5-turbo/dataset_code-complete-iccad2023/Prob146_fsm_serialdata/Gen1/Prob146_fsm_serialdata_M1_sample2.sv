module TopModule (
  input clk,
  input in,
  input reset,
  output reg [7:0] out_byte,
  output reg done
);

  reg [3:0] state;
  reg [7:0] shift_reg;
  reg [2:0] bit_counter;
  
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= 4'b0000;
      shift_reg <= 8'b0;
      bit_counter <= 3'b000;
      out_byte <= 8'b0;
      done <= 1'b0;
    end
    else begin
      case (state)
        4'b0000: begin // Idle state, waiting for start bit
          if (in == 1'b0) begin
            state <= 4'b0001; // Transition to start bit detected state
            bit_counter <= 3'b000; // Reset bit counter
          end
        end
        4'b0001: begin // Start bit detected, receive 8 data bits
          shift_reg <= {in, shift_reg[7:1]};
          bit_counter <= bit_counter + 1;
          if (bit_counter == 3'b111) begin
            state <= 4'b0010; // Transition to stop bit expected state
          end
        end
        4'b0010: begin // Stop bit expected
          if (in == 1'b1) begin
            out_byte <= shift_reg;
            done <= 1'b1;
            state <= 4'b0000; // Transition to idle state
          end
          else begin
            state <= 4'b0000; // Wrong stop bit detected, return to idle state
          end
        end
      endcase
    end
  end
  
endmodule
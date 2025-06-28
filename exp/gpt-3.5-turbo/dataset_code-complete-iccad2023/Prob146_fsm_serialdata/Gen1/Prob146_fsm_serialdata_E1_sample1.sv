module TopModule (
  input clk,
  input in,
  input reset,
  output reg [7:0] out_byte,
  output reg done
);
  
  reg [2:0] state;
  reg [7:0] shift_reg;
  reg [3:0] bit_count;
  
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= 3'b000;
      shift_reg <= 8'b0;
      bit_count <= 4'b0000;
      out_byte <= 8'b0;
      done <= 1'b0;
    end
    else begin
      case (state)
        3'b000: begin // Idle state, waiting for start bit
          if (in == 1'b0) begin
            state <= 3'b001; // Transition to start bit detected state
            bit_count <= 4'b0001; // Reset bit count
          end
        end
        3'b001: begin // Start bit detected, receive 8 data bits
          shift_reg <= {in, shift_reg[7:1]};
          bit_count <= bit_count + 1;
          if (bit_count == 8) begin
            state <= 3'b010; // Transition to stop bit expected state
          end
        end
        3'b010: begin // Stop bit expected
          if (bit_count == 9 && in == 1'b1) begin
            out_byte <= shift_reg;
            done <= 1'b1;
            state <= 3'b011; // Transition to wait for stop bit state
          end
          else if (in == 1'b1) begin
            state <= 3'b011; // If unexpected stop bit, wait for next start bit
          end
        end
        3'b011: begin // Waiting for next start bit
          if (in == 1'b0) begin
            state <= 3'b001; // Transition to start bit detected state
            bit_count <= 4'b0001; // Reset bit count
          end
        end
      endcase
    end
  end
  
endmodule
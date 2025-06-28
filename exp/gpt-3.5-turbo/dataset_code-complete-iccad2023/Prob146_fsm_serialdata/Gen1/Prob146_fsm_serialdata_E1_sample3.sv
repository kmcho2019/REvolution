module TopModule (
  input clk,
  input in,
  input reset,
  output reg [7:0] out_byte,
  output reg done
);

  // Internal signals
  reg [3:0] bit_counter; // Count the number of bits received
  reg [7:0] shift_reg; // Shift register to collect incoming bits
  reg start_detected; // Flag to track start bit detection

  // FSM logic
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      bit_counter <= 0;
      shift_reg <= 8'b0;
      start_detected <= 0;
      out_byte <= 8'b0;
      done <= 0;
    end else begin
      if (start_detected) begin
        bit_counter <= bit_counter + 1;
        
        // Shift in the received bit
        shift_reg <= {shift_reg[6:0], in};
        
        // Collect all 8 data bits
        if (bit_counter >= 1 && bit_counter <= 8) begin
          out_byte <= {shift_reg[6:0], out_byte[7:1]};
        end
        
        // Verify stop bit
        if (bit_counter == 9) begin
          if (in) begin
            // Stop bit detected
            done <= 1;
            start_detected <= 0;
          end else begin
            // Wait for the correct stop bit
            start_detected <= 0;
          end
        end
      end else begin
        // Wait for the start bit (0)
        start_detected <= (in == 0);
        if (start_detected) begin
          bit_counter <= 0;
        end
      end
    end
  end

endmodule
module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);

reg [7:0] shift_reg [2:0];

always @(posedge clk or posedge reset) begin
  if (reset) begin
    done <= 0;
    shift_reg[0] <= 8'h00;
    shift_reg[1] <= 8'h00;
    shift_reg[2] <= 8'h00;
  end else begin
    // Shift register to store last 3 bytes
    shift_reg <= {in, shift_reg[0], shift_reg[1]};
    
    if (shift_reg[7] == 1 && shift_reg[15] == 0 && shift_reg[23] == 0) begin
      out_bytes <= {shift_reg[6:0], shift_reg[14:8], shift_reg[22:16]};
      done <= 1;
    end else begin
      out_bytes <= 24'h0; // Clear output bytes if no valid message
    end
  end
end

endmodule
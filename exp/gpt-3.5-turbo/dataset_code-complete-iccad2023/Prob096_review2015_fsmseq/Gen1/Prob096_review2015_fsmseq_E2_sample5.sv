module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

reg [3:0] shift_reg;
reg [1:0] prev_bits;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    shift_reg <= 4'b0000;
    prev_bits <= 2'b00;
    start_shifting <= 0;
  end
  else begin
    // Shift in new data
    shift_reg <= {shift_reg[2:0], data};
    prev_bits <= {prev_bits[0], data};
    
    // Determine next state based on the shift register
    case (shift_reg)
      4'b1101: begin // Sequence found in current bits
        start_shifting <= 1;
      end
    endcase
  end
end

endmodule
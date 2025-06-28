module TopModule (
  input clk,
  input a,
  output reg q
);

  reg [1:0] shift_reg;

  always @(posedge clk) begin
    // Shift left
    shift_reg <= {shift_reg[0], shift_reg[1]};
    
    // Load input 'a' into LSB
    shift_reg[0] <= a;
    
    // Output MSB
    q <= shift_reg[1];
  end

endmodule
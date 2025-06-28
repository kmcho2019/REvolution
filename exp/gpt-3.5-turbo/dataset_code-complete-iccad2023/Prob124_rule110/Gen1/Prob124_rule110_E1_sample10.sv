module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);

  always @ (posedge clk) begin
    if (load) begin
      q <= data; // Load data when load is active
    end else begin
      reg [511:0] q_shifted; // Shift register to store the shifted state of cells
        
      // Shift current state and neighboring states
      q_shifted = {q[510:0], 1'b0};
      
      // Apply Rule 110 using bitwise operations
      q = q ^ (q & q_shifted) ^ (q & ~{q[510], 1'b0}) ^ (~q & q_shifted);
    end
  end

endmodule
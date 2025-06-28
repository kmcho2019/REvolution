module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);
  
  always @ (posedge clk) begin
    if (load) begin
      q <= data; // Load initial state from input data
    end else begin
      // Apply Rule 110 for each cell in the array
      for (int i = 0; i < 512; i = i + 1) begin
        // Concatenate neighbor cells' states with the current cell for mapping Rule 110
        reg [2:0] cell_states = (i == 0) ? {1'b0, q[i], q[i+1]} : 
                                 (i == 511) ? {q[i-1], q[i], 1'b0} : {q[i-1], q[i], q[i+1]};
        
        // Apply Rule 110 using XOR operations to directly map the truth table
        q[i] <= {(~cell_states[0] & cell_states[1] & cell_states[2]) ^ cell_states[1]};
      end
    end
  end

endmodule
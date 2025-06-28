module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);

  reg [511:0] nextState; // Temporary array to hold the next state of all cells

  always @(posedge clk) begin
    if (load) begin
      q <= data; // Load data when load is active
    end else begin
      // Calculate the next state of all cells simultaneously
      for (int i = 0; i < 512; i = i + 1) begin
        // Define the boundaries where the two adjacent cell states are 0
        int left = (i == 0) ? 0 : q[i-1];
        int right = (i == 511) ? 0 : q[i+1];
        
        // Implement Rule 110
        case({left, q[i], right})
          3'b111: nextState[i] = 0;
          3'b110: nextState[i] = 1;
          3'b101: nextState[i] = 1;
          3'b100: nextState[i] = 0;
          3'b011: nextState[i] = 1;
          3'b010: nextState[i] = 1;
          3'b001: nextState[i] = 1;
          3'b000: nextState[i] = 0;
        endcase
      end
      
      // Update main array 'q' synchronously with the next state
      q <= nextState;
    end
  end

endmodule
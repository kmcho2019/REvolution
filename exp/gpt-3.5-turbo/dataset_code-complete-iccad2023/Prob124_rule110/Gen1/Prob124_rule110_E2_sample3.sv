module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);

  always @(posedge clk) begin
    if (load) begin
      q <= data; // Load data if load signal is high
    end else begin
      // Temporary storage for the next state of all cells
      reg [511:0] next_state;
      
      // Implement Rule 110 for each cell except boundaries
      for (int i = 0; i < 512; i = i + 1) begin
        if (i == 0) begin
          // Handle left boundary
          next_state[0] = 1'b0;
        end else if (i == 511) begin
          // Handle right boundary
          next_state[511] = 1'b0;
        end else begin
          // Apply Rule 110 logic
          case ({q[i-1], q[i], q[i+1]})
            // Rule 110 conditions
            3'b111: next_state[i] = 1'b0;
            3'b110: next_state[i] = 1'b1;
            3'b101: next_state[i] = 1'b1;
            3'b100: next_state[i] = 1'b0;
            3'b011: next_state[i] = 1'b1;
            3'b010: next_state[i] = 1'b1;
            3'b001: next_state[i] = 1'b1;
            3'b000: next_state[i] = 1'b0;
          endcase
        end
      end
      
      // Update all cells simultaneously
      q <= next_state;
    end
  end

endmodule
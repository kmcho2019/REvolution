module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);

  reg [7:0] rule110_table [0:7]; // Lookup table for Rule 110 transitions

  // Initialize Rule 110 lookup table
  initial begin
    rule110_table[3'b111] = 1;
    rule110_table[3'b110] = 0;
    rule110_table[3'b101] = 1;
    rule110_table[3'b100] = 1;
    rule110_table[3'b011] = 1;
    rule110_table[3'b010] = 1;
    rule110_table[3'b001] = 1;
    rule110_table[3'b000] = 0;
  end

  always @(posedge clk) begin
    if (load) begin
      q <= data; // Load data if load signal is high
    end else begin
      reg [7:0] next_state; // Temporary storage for next states
      next_state[0] = 0; // Initialize boundary cell state
      next_state[511] = 0; // Initialize boundary cell state

      // Compute next states for each cell except boundaries
      for (int i = 1; i < 511; i = i + 1) begin
        next_state[i] = rule110_table[{q[i-1], q[i], q[i+1]}]; // Lookup next state
      end
      
      q <= next_state; // Update all cell states simultaneously
    end
  end

endmodule
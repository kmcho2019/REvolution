module TopModule(output reg out);
  // Always hold output at 0 by initializing and assigning in an always block.
  initial begin
    out = 1'b0; // Initialize output to 0
  end

  // No clock, no change; output remains at 0.
  always @(*) begin
    out = 1'b0; // Constantly drive 0
  end
endmodule
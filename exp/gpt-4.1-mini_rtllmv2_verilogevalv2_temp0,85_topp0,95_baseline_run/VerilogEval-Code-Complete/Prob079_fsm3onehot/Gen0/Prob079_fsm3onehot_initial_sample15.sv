module TopModule (
  input in,
  input [3:0] state,
  output reg [3:0] next_state,
  output out
);

  always @(*) begin
    // Default next_state to 0
    next_state = 4'b0000;

    // Next state logic by state and input
    // State A (0001)
    if (state[0]) begin
      if (in == 0)
        next_state = 4'b0001; // A
      else
        next_state = 4'b0010; // B
    end
    // State B (0010)
    else if (state[1]) begin
      if (in == 0)
        next_state = 4'b0100; // C
      else
        next_state = 4'b0010; // B
    end
    // State C (0100)
    else if (state[2]) begin
      if (in == 0)
        next_state = 4'b0001; // A
      else
        next_state = 4'b1000; // D
    end
    // State D (1000)
    else if (state[3]) begin
      if (in == 0)
        next_state = 4'b0100; // C
      else
        next_state = 4'b0010; // B
    end
    else begin
      next_state = 4'b0001; // default to A if no valid state
    end
  end

  // Output logic (Moore)
  assign out = state[3]; // output 1 only in state D

endmodule
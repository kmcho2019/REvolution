module TopModule (
  input in,
  input [9:0] state,
  output reg [9:0] next_state,
  output reg out1,
  output reg out2
);

  always @(*) begin
    // Default outputs and next_state are zero
    next_state = 10'b0;
    out1 = 0;
    out2 = 0;

    // State S0 (state[0])
    if (state[0]) begin
      if (in == 0)
        next_state[0] = 1'b1; // S0
      else
        next_state[1] = 1'b1; // S1
    end

    // State S1 (state[1])
    else if (state[1]) begin
      if (in == 0)
        next_state[0] = 1'b1; // S0
      else
        next_state[2] = 1'b1; // S2
    end

    // State S2 (state[2])
    else if (state[2]) begin
      if (in == 0)
        next_state[0] = 1'b1; // S0
      else
        next_state[3] = 1'b1; // S3
    end

    // State S3 (state[3])
    else if (state[3]) begin
      if (in == 0)
        next_state[0] = 1'b1; // S0
      else
        next_state[4] = 1'b1; // S4
    end

    // State S4 (state[4])
    else if (state[4]) begin
      if (in == 0)
        next_state[0] = 1'b1; // S0
      else
        next_state[5] = 1'b1; // S5
    end

    // State S5 (state[5])
    else if (state[5]) begin
      if (in == 0)
        next_state[8] = 1'b1; // S8
      else
        next_state[6] = 1'b1; // S6
    end

    // State S6 (state[6])
    else if (state[6]) begin
      if (in == 0)
        next_state[9] = 1'b1; // S9
      else
        next_state[7] = 1'b1; // S7
    end

    // State S7 (state[7]) - outputs (0,1)
    else if (state[7]) begin
      out1 = 0;
      out2 = 1;
      if (in == 0)
        next_state[0] = 1'b1; // S0
      else
        next_state[7] = 1'b1; // S7
    end

    // State S8 (state[8]) - outputs (1,0)
    else if (state[8]) begin
      out1 = 1;
      out2 = 0;
      if (in == 0)
        next_state[0] = 1'b1; // S0
      else
        next_state[1] = 1'b1; // S1
    end

    // State S9 (state[9]) - outputs (1,1)
    else if (state[9]) begin
      out1 = 1;
      out2 = 1;
      if (in == 0)
        next_state[0] = 1'b1; // S0
      else
        next_state[1] = 1'b1; // S1
    end
  end

endmodule
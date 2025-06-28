module TopModule (
  input in,
  input [9:0] state,
  output [9:0] next_state,
  output out1,
  output out2
);

  // State transition logic
  always @(state, in) begin
    next_state = 10'b0; // Initialize next_state to all zeros

    case(state)
      // State S0 transitions
      10'b0000000001: begin
        if(in == 1)
          next_state = 10'b0000000010; // S0 -> S1
      end

      // State S1 transitions
      10'b0000000010: begin
        if(in == 1)
          next_state = 10'b0000000100; // S1 -> S2
      end

      // State S2 transitions
      10'b0000000100: begin
        if(in == 1)
          next_state = 10'b0000001000; // S2 -> S3
      end

      // State S3 transitions
      10'b0000001000: begin
        if(in == 1)
          next_state = 10'b0000010000; // S3 -> S4
      end

      // State S4 transitions
      10'b0000010000: begin
        if(in == 1)
          next_state = 10'b0000100000; // S4 -> S5
      end

      // State S5 transitions
      10'b0000100000: begin
        if(in == 1)
          next_state = 10'b0010000000; // S5 -> S8
      end

      // State S5 outputs
      10'b0000100000, 10'b0010000000: begin
        out1 = 0;
        out2 = 0;
      end

      // State S6 transitions
      10'b0001000000: begin
        if(in == 1)
          next_state = 10'b0010000000; // S6 -> S7
      end

      // State S6 outputs
      10'b0001000000: begin
        out1 = 0;
        out2 = 0;
      end

      // State S7 transitions
      10'b0010000000: begin
        if(in == 0)
          next_state = 10'b0000000001; // S7 -> S0
      end

      // State S7 outputs
      10'b0010000000: begin
        out1 = 0;
        out2 = 1;
      end

      // State S8 transitions
      10'b0100000000: begin
        if(in == 1)
          next_state = 10'b0000000010; // S8 -> S1
      end

      // State S8 outputs
      10'b0100000000: begin
        out1 = 1;
        out2 = 0;
      end

      // State S9 transitions
      10'b1000000000: begin
        if(in == 1)
          next_state = 10'b0000000010; // S9 -> S1
      end

      // State S9 outputs
      10'b1000000000: begin
        out1 = 1;
        out2 = 1;
      end

      default: begin
        next_state = 10'b0000000001; // Default to S0
        out1 = 0;
        out2 = 0;
      end
    endcase
  end

endmodule
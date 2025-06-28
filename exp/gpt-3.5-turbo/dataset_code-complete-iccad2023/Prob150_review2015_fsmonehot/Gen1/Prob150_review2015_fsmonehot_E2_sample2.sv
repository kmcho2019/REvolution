module TopModule (
  input d,
  input done_counting,
  input ack,
  input [9:0] state, // 10-bit one-hot current state
  output B3_next,
  output S_next,
  output S1_next,
  output Count_next,
  output Wait_next,
  output done,
  output counting,
  output shift_ena
);

  reg [9:0] current_state;

  // State transition logic
  always @* begin
    case(current_state)
      10'b0000000001: begin // S
        if (d) current_state = 10'b0000000010; // S1
        else current_state = 10'b0000000001; // S
      end
      10'b0000000010: begin // S1
        if (d) current_state = 10'b0000000100; // S11
        else current_state = 10'b0000000001; // S
      end
      10'b0000000100: begin // S11
        if (d) current_state = 10'b0000001000; // S110
        else current_state = 10'b0000000100; // S11
      end
      10'b0000001000: begin // S110
        if (d) current_state = 10'b0000010000; // B0
        else current_state = 10'b0000000001; // S
      end
      10'b0000010000: current_state = 10'b0000100000; // B0 -> B1
      10'b0000100000: current_state = 10'b0001000000; // B1 -> B2
      10'b0001000000: current_state = 10'b0010000000; // B2 -> B3
      10'b0010000000: current_state = 10'b0100000000; // B3 -> Count
      10'b0100000000: begin // Count
        if (done_counting) current_state = 10'b1000000000; // Wait
        else current_state = 10'b0100000000; // Count
      end
      10'b1000000000: begin // Wait
        if (ack) current_state = 10'b0000000001; // S
        else current_state = 10'b1000000000; // Wait
      end
      default: current_state = 10'b0000000001; // Default state is S
    endcase
  end

  // Assign next-state outputs
  assign B3_next = (current_state == 10'b0010000000) ? 1'b1 : 1'b0;
  assign S_next = (current_state == 10'b0000000001) ? 1'b1 : 1'b0;
  assign S1_next = (current_state == 10'b0000000010) ? 1'b1 : 1'b0;
  assign Count_next = (current_state == 10'b0100000000) ? 1'b1 : 1'b0;
  assign Wait_next = (current_state == 10'b1000000000) ? 1'b1 : 1'b0;

  // Output logic equations
  assign done = (current_state == 10'b1000000000) ? 1'b1 : 1'b0; // done signal logic
  assign counting = (current_state == 10'b0100000000 || current_state == 10'b1000000000) ? 1'b1 : 1'b0; // counting signal logic
  assign shift_ena = (current_state == 10'b0000010000) ? 1'b1 : 1'b0; // shift_ena signal logic

endmodule
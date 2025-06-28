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

  // Output Logic
  assign done = (state == 10'b1000000000) ? 1'b1 : 1'b0; // done only in Wait state
  assign counting = (state == 10'b0100000000) ? 1'b1 : 1'b0; // counting only in Count state
  assign shift_ena = (state >= 10'b0000010000) ? 1'b1 : 1'b0; // shift_ena in B0 state onwards

  // State Transition Logic
  always @* begin
    case (state)
      10'b0000000001: begin // S
        S_next = 1'b1;
        if (d) state = 10'b0000000010;
        else state = 10'b0000000001;
      end
      10'b0000000010: begin // S1
        S1_next = 1'b1;
        if (d) state = 10'b0000000100;
        else state = 10'b0000000001;
      end
      10'b0000000100: begin // S11
        if (d) state = 10'b0000000100;
        else state = 10'b0000001000;
      end
      10'b0000001000: begin // S110
        if (d) state = 10'b0000010000;
        else state = 10'b0000000001;
      end
      10'b0000010000: state = 10'b0000100000; // B0
      10'b0000100000: state = 10'b0001000000; // B1
      10'b0001000000: state = 10'b0010000000; // B2
      10'b0010000000: state = 10'b0100000000; // B3
      10'b0100000000: begin // Count
        Count_next = 1'b1;
        if (done_counting) state = 10'b1000000000;
        else state = 10'b0100000000;
      end
      10'b1000000000: begin // Wait
        Wait_next = 1'b1;
        if (ack) state = 10'b0000000001;
        else state = 10'b1000000000;
      end
      default: state = 10'b0000000001; // Default to S state
    endcase
  end

endmodule
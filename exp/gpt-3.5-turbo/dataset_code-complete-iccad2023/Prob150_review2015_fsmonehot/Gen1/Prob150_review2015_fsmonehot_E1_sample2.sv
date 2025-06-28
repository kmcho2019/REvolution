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

  // Define state encodings
  parameter S = 10'b0000000001;
  parameter S1 = 10'b0000000010;
  parameter S11 = 10'b0000000100;
  parameter S110 = 10'b0000001000;
  parameter B0 = 10'b0000010000;
  parameter B1 = 10'b0000100000;
  parameter B2 = 10'b0001000000;
  parameter B3 = 10'b0010000000;
  parameter Count = 10'b0100000000;
  parameter Wait = 10'b1000000000;

  always @* begin
    // Default assignments
    B3_next = 1'b0;
    S_next = 1'b0;
    S1_next = 1'b0;
    Count_next = 1'b0;
    Wait_next = 1'b0;
    done = 1'b0;
    counting = 1'b0;
    shift_ena = 1'b0;

    // State transition and output logic based on the current state
    case(state)
      S: begin
        S_next = 1'b1;
        if (d) S1_next = 1'b1;
      end
      S1: begin
        S_next = 1'b1;
        if (d) S11 = 1'b1;
      end
      S11: begin
        if (!d) S110 = 1'b1;
        S11 = 1'b1;
      end
      S110: begin
        if (d) B0 = 1'b1;
      end
      B0: begin
        B3_next = 1'b1;
        shift_ena = 1'b1;
      end
      B1: begin
        B3_next = 1'b1;
        shift_ena = 1'b1;
      end
      B2: begin
        B3_next = 1'b1;
        shift_ena = 1'b1;
      end
      B3: begin
        B3_next = 1'b1;
        shift_ena = 1'b1;
      end
      Count: begin
        if (done_counting) Wait_next = 1'b1;
        else Count_next = 1'b1;
        counting = 1'b1;
      end
      Wait: begin
        if (ack) S_next = 1'b1;
        done = 1'b1;
      end
    endcase
  end
endmodule
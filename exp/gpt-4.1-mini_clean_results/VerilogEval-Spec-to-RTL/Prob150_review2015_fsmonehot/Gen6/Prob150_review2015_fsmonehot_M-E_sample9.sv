module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,        // one-hot encoded as (S=bit0,... Wait=bit9)
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

  // Decode current one-hot states
  wire S     = state[0];
  wire S1    = state[1];
  wire S11   = state[2];
  wire S110  = state[3];
  wire B0    = state[4];
  wire B1    = state[5];
  wire B2    = state[6];
  wire B3    = state[7];
  wire Count = state[8];
  wire Wait  = state[9];

  // Intermediate signals to capture next states derived from input conditions

  // Next state S triggered by:
  // - from S, S1, S110 if d==0
  // - from Wait if ack==1
  wire in_S_states_d0 = (S | S1 | S110) & (~d);
  wire in_Wait_ack   = Wait & ack;
  assign S_next = in_S_states_d0 | in_Wait_ack;

  // Next state S1 triggered by S when d==1
  assign S1_next = S & d;

  // Next state S11 triggered by S1 when d==1
  // Not requested as output signal, but needed for completeness of understanding
  // (Not required to implement output next signals for all states; only those requested)

  // Next state S110 triggered by S11 when d==0

  // Next state B0 triggered by S110 when d==1
  // B0 has no output next signal as per requirement, so no output for it here.

  // Next states along B chain happen unconditionally in sequence:
  // B0->B1, B1->B2, B2->B3, B3->Count

  // Use these conditions to build B3_next signal (asserted when next state is B3)
  assign B3_next = B2;

  // Count_next when next state is Count:
  // - from B3 (unconditional)
  // - stay in Count if done_counting==0
  wire count_stay = Count & (~done_counting);
  assign Count_next = B3 | count_stay;

  // Wait_next when next state is Wait:
  // - from Count if done_counting==1
  // - stay in Wait if ack==0
  wire wait_stay = Wait & (~ack);
  assign Wait_next = (Count & done_counting) | wait_stay;

  // Output logic for shift_ena (asserted during B0-B3)
  assign shift_ena = B0 | B1 | B2 | B3;

  // counting asserted in Count state
  assign counting = Count;

  // done asserted in Wait state
  assign done = Wait;

endmodule
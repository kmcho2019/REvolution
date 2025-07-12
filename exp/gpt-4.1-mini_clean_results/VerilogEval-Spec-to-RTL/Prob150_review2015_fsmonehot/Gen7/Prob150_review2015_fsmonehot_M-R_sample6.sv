module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,        // one-hot encoded
    output B3_next,
    output S_next,
    output S1_next,
    output Count_next,
    output Wait_next,
    output done,
    output counting,
    output shift_ena
);

  // Define state indices for readability
  localparam S_IDX    = 0;
  localparam S1_IDX   = 1;
  localparam S11_IDX  = 2;
  localparam S110_IDX = 3;
  localparam B0_IDX   = 4;
  localparam B1_IDX   = 5;
  localparam B2_IDX   = 6;
  localparam B3_IDX   = 7;
  localparam COUNT_IDX= 8;
  localparam WAIT_IDX = 9;

  // Function to decode one-hot to state index
  function integer get_state_index(input [9:0] state_in);
    integer i;
    begin
      get_state_index = -1;
      for (i=0; i<10; i=i+1) begin
        if(state_in[i]) get_state_index = i;
      end
    end
  endfunction

  wire [3:0] curr_state = get_state_index(state);

  // Declare next state one-hot signals
  reg [9:0] next_state;

  always @(*) begin
    // default no next state
    next_state = 10'b0;

    case(curr_state)
      S_IDX:    next_state[d ? S1_IDX : S_IDX] = 1'b1;
      S1_IDX:   next_state[d ? S11_IDX : S_IDX] = 1'b1;
      S11_IDX:  next_state[d ? S11_IDX : S110_IDX] = 1'b1;
      S110_IDX: next_state[d ? B0_IDX : S_IDX] = 1'b1;
      B0_IDX:   next_state[B1_IDX] = 1'b1;
      B1_IDX:   next_state[B2_IDX] = 1'b1;
      B2_IDX:   next_state[B3_IDX] = 1'b1;
      B3_IDX:   next_state[COUNT_IDX] = 1'b1;
      COUNT_IDX:next_state[done_counting ? WAIT_IDX : COUNT_IDX] = 1'b1;
      WAIT_IDX: next_state[ack ? S_IDX : WAIT_IDX] = 1'b1;
      default:  next_state[S_IDX] = 1'b1; // fallback to S
    endcase
  end

  // Next state signals requested (assert when next state is that state)
  assign S_next     = next_state[S_IDX];
  assign S1_next    = next_state[S1_IDX];
  assign B3_next    = next_state[B3_IDX];
  assign Count_next = next_state[COUNT_IDX];
  assign Wait_next  = next_state[WAIT_IDX];

  // Output logic (Moore)
  assign shift_ena = |(next_state[B0_IDX] | next_state[B1_IDX] | next_state[B2_IDX] | next_state[B3_IDX]);
  assign counting  = next_state[COUNT_IDX];
  assign done      = next_state[WAIT_IDX];

endmodule
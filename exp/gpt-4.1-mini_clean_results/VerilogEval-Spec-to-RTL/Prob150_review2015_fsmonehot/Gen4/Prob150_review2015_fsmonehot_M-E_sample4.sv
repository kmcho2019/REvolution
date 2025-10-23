module TopModule(
    input  d,
    input  done_counting,
    input  ack,
    input  [9:0] state,        // one-hot encoded current state
    output reg B3_next,
    output reg S_next,
    output reg S1_next,
    output reg Count_next,
    output reg Wait_next,
    output reg done,
    output reg counting,
    output reg shift_ena
);

  // Define state indices for clarity
  localparam S_idx    = 0;
  localparam S1_idx   = 1;
  localparam S11_idx  = 2;
  localparam S110_idx = 3;
  localparam B0_idx   = 4;
  localparam B1_idx   = 5;
  localparam B2_idx   = 6;
  localparam B3_idx   = 7;
  localparam Count_idx= 8;
  localparam Wait_idx = 9;

  // Decode current one-hot state to integer for case statement
  // Since exactly one bit is set in 'state', find index of that bit
  integer i;
  reg [3:0] current_state; // enough bits to index 0..9

  always @(*) begin
    current_state = 4'd0;
    for (i=0; i<10; i=i+1) begin
      if (state[i])
        current_state = i[3:0];
    end
  end

  // Next-state and output logic combinational block
  always @(*) begin
    // Defaults
    B3_next    = 1'b0;
    S_next     = 1'b0;
    S1_next    = 1'b0;
    Count_next = 1'b0;
    Wait_next  = 1'b0;
    done       = 1'b0;
    counting   = 1'b0;
    shift_ena  = 1'b0;

    case(current_state)
      S_idx: begin
        // S: d=0->S, d=1->S1
        S_next  = ~d;
        S1_next = d;
      end

      S1_idx: begin
        // S1: d=0->S, d=1->S11
        S_next  = ~d;
        // next state S11 means neither S nor S1, so zero both and they remain 0
        // no output signals for S11's next state, but we must express only requested outputs
        // so only S_next and S1_next asserted as per problem statement
        if (d) begin
          // next state is S11 - none of requested next state signals asserted
          S_next = 1'b0;
          S1_next = 1'b0;
        end
      end

      S11_idx: begin
        // S11: d=0->S110, d=1->S11 (stay)
        if (d) begin
          // stay in S11: no S_next or S1_next asserted
          S_next = 1'b0;
          S1_next = 1'b0;
        end else begin
          // go to S110: no S or S1 next state asserted
          S_next = 1'b0;
          S1_next = 1'b0;
        end
      end

      S110_idx: begin
        // S110: d=0->S, d=1->B0
        if (~d) begin
          S_next = 1'b1;
        end else begin
          // go to B0: B3_next not asserted here; only shift_ena output is for B0-B3 states
          // B3_next asserts only when next state is B3, so no B3_next here
          // no direct outputs to set here for B0 state (no requested next outputs)
          S_next = 1'b0;
          S1_next = 1'b0;
        end
      end

      B0_idx: begin
        // B0: always go to B1, shift_ena=1
        shift_ena = 1'b1;
        // next states not requested except B3_next: so none asserted here
        // only B3_next asserted when next state is B3 (later)
      end

      B1_idx: begin
        // B1: always go to B2, shift_ena=1
        shift_ena = 1'b1;
      end

      B2_idx: begin
        // B2: always go to B3, shift_ena=1
        shift_ena = 1'b1;
        B3_next = 1'b1;
      end

      B3_idx: begin
        // B3: always go to Count, shift_ena=1
        shift_ena = 1'b1;
        Count_next = 1'b1;
      end

      Count_idx: begin
        // Count: counting=1; done_counting=0->Count, done_counting=1->Wait
        counting = 1'b1;
        if (done_counting) begin
          Wait_next = 1'b1;
        end else begin
          Count_next = 1'b1;
        end
      end

      Wait_idx: begin
        // Wait: done=1; ack=0->Wait, ack=1->S
        done = 1'b1;
        if (ack) begin
          S_next = 1'b1;
        end else begin
          Wait_next = 1'b1;
        end
      end

      default: begin
        // no next state or outputs asserted for invalid states
      end
    endcase
  end

endmodule
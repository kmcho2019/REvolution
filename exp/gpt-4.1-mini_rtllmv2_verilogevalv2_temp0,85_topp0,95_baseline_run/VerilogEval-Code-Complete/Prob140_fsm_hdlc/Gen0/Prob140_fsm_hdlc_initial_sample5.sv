module TopModule (
  input clk,
  input reset,
  input in,
  output disc,
  output flag,
  output err
);

  // State encoding (Moore FSM)
  typedef enum logic [3:0] {
    S0 = 4'd0,  // previous input was 0 (or reset)
    S1 = 4'd1,  // 1 consecutive 1s
    S2 = 4'd2,  // 2 consecutive 1s
    S3 = 4'd3,  // 3 consecutive 1s
    S4 = 4'd4,  // 4 consecutive 1s
    S5 = 4'd5,  // 5 consecutive 1s
    S6 = 4'd6,  // 6 consecutive 1s
    SE = 4'd7   // error state (7 or more consecutive 1s)
  } state_t;

  state_t state, next_state;

  // Outputs are registered outputs depending on current state and input
  // Because Moore FSM outputs depend on state only, outputs must be designed carefully:
  // We use states to indicate that the event occurred on previous cycle.
  //
  // To produce outputs one cycle after event:
  // - After detecting disc condition (input=0 after S5), go to S0
  //   but in that next cycle output disc=1.
  //   So we can encode that by using separate output signals registered,
  //   triggered by transitions.
  //
  // Alternatively, we can augment states with output flags:
  // After receiving the event, transition to a special output state that asserts output signals for one cycle.

  // To achieve that, introduce intermediate output states for disc, flag, err output assertions.

  typedef enum logic [4:0] {
    ST_S0    = 5'd0,
    ST_S1    = 5'd1,
    ST_S2    = 5'd2,
    ST_S3    = 5'd3,
    ST_S4    = 5'd4,
    ST_S5    = 5'd5,
    ST_S6    = 5'd6,
    ST_SE    = 5'd7,
    ST_DISC  = 5'd8,  // disc output asserted 1 cycle
    ST_FLAG  = 5'd9,  // flag output asserted 1 cycle
    ST_ERR   = 5'd10  // err output asserted 1 cycle
  } state_full_t;

  state_full_t cur_state, nxt_state;

  // Next state logic
  always @(*) begin
    case (cur_state)
      ST_S0: begin
        if(in == 1'b1) nxt_state = ST_S1;
        else           nxt_state = ST_S0;
      end

      ST_S1: begin
        if(in == 1'b1) nxt_state = ST_S2;
        else           nxt_state = ST_S0;
      end

      ST_S2: begin
        if(in == 1'b1) nxt_state = ST_S3;
        else           nxt_state = ST_S0;
      end

      ST_S3: begin
        if(in == 1'b1) nxt_state = ST_S4;
        else           nxt_state = ST_S0;
      end

      ST_S4: begin
        if(in == 1'b1) nxt_state = ST_S5;
        else           nxt_state = ST_S0;
      end

      ST_S5: begin
        if(in == 1'b1) nxt_state = ST_S6; // 6 consecutive ones
        else           nxt_state = ST_DISC; // zero after five 1s -> discard event
      end

      ST_S6: begin
        if(in == 1'b1) nxt_state = ST_ERR; // 7 consecutive ones: error
        else           nxt_state = ST_FLAG; // zero after six 1s -> flag event
      end

      // Output states, assert outputs for one cycle then return to base state
      ST_DISC: begin
        // after disc output, treat current input as reset: if in=1, go to S1 else S0
        if(in == 1'b1) nxt_state = ST_S1;
        else           nxt_state = ST_S0;
      end

      ST_FLAG: begin
        // after flag output, same as above
        if(in == 1'b1) nxt_state = ST_S1;
        else           nxt_state = ST_S0;
      end

      ST_ERR: begin
        // remain in error state until reset (sticky error)
        nxt_state = ST_ERR;
      end

      default: nxt_state = ST_S0;
    endcase
  end

  // State register
  always @(posedge clk) begin
    if (reset) begin
      cur_state <= ST_S0;
    end else begin
      cur_state <= nxt_state;
    end
  end

  // Outputs based on current state (Moore)
  assign disc = (cur_state == ST_DISC);
  assign flag = (cur_state == ST_FLAG);
  assign err  = (cur_state == ST_ERR);

endmodule
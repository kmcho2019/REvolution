module TopModule (
  input clk,
  input reset,
  input in,
  output disc,
  output flag,
  output err
);

  // State encoding: count of consecutive 1s seen so far (0 to 7+)
  // 0: no consecutive ones
  // 1..5: count of consecutive ones
  // 6: exactly 6 consecutive ones
  // 7: error state (7 or more consecutive ones)
  reg [3:0] state, next_state;

  // Output registers for Moore FSM outputs
  reg disc_r, flag_r, err_r;

  // State encoding parameters for clarity
  localparam S0 = 4'd0,
             S1 = 4'd1,
             S2 = 4'd2,
             S3 = 4'd3,
             S4 = 4'd4,
             S5 = 4'd5,
             S6 = 4'd6,
             S7 = 4'd7;  // error state (7 or more ones)

  // Next state logic
  always @(*) begin
    case(state)
      S0: begin
        if(in == 1'b1) next_state = S1;
        else           next_state = S0;
      end

      S1: begin
        if(in == 1'b1) next_state = S2;
        else           next_state = S0;
      end

      S2: begin
        if(in == 1'b1) next_state = S3;
        else           next_state = S0;
      end

      S3: begin
        if(in == 1'b1) next_state = S4;
        else           next_state = S0;
      end

      S4: begin
        if(in == 1'b1) next_state = S5;
        else           next_state = S0;
      end

      S5: begin
        if(in == 1'b1) next_state = S6; // 6 consecutive ones
        else           next_state = S0; // disc condition detected (5 ones then 0)
      end

      S6: begin
        if(in == 1'b1) next_state = S7; // error: 7 consecutive ones
        else           next_state = S0; // flag condition detected (6 ones then 0)
      end

      S7: begin
        if(in == 1'b1) next_state = S7; // stay in error state
        else           next_state = S0; // reset error on zero input
      end

      default: next_state = S0;
    endcase
  end

  // Output logic (Moore FSM): outputs asserted for a full cycle starting on next clock after detection
  // We set the outputs based on the *previous* state and current input that caused transition to next_state.
  // But outputs only depend on current state in Moore FSM, so we will register outputs in sequential block.
  // We detect the disc, flag, err conditions when leaving S5 or S6 to S0 or S7, so outputs are asserted when in states S0 or S7 
  // following the pattern.

  always @(posedge clk) begin
    if(reset) begin
      state <= S0;
      disc_r <= 1'b0;
      flag_r <= 1'b0;
      err_r <= 1'b0;
    end else begin
      state <= next_state;

      // Default outputs off
      disc_r <= 1'b0;
      flag_r <= 1'b0;
      err_r <= 1'b0;

      // Detect outputs based on previous state and input:
      // disc: pattern 0111110 detected means after S5 state and input 0 => next_state=S0
      // flag: pattern 01111110 detected means after S6 state and input 0 => next_state=S0
      // err: 7 or more ones => next_state=S7

      // Because outputs are Moore-type and asserted one cycle after detection,
      // we assert outputs in the cycle AFTER transition.

      // So the FSM asserts outputs when in states S0 or S7 after the respective transitions:

      case(state)
        S0: begin
          // Check if last transition was from S5 with input=0 (disc)
          // or from S6 with input=0 (flag)
          // We don't have direct access to last input here, but we know the transitions.
          // To detect these conditions, let's store previous state in a register.

          // This is handled below by prev_state
        end

        S7: begin
          // err asserted when in error state
          err_r <= 1'b1;
        end

        default: begin
          // no outputs asserted in other states
        end
      endcase
    end
  end

  // To detect disc and flag, save previous state and input:
  reg [3:0] prev_state;
  reg prev_in;

  always @(posedge clk) begin
    if(reset) begin
      prev_state <= S0;
      prev_in <= 1'b0;
    end else begin
      prev_state <= state;
      prev_in <= in;
    end
  end

  // Generate disc and flag outputs based on previous state and input and current state
  // Outputs asserted for one cycle after detection (i.e., when FSM is in state after the pattern)
  wire disc_w = (prev_state == S5) && (prev_in == 1'b0) && (state == S0);
  wire flag_w = (prev_state == S6) && (prev_in == 1'b0) && (state == S0);

  // Set disc_r and flag_r accordingly (already set err_r in always @(posedge clk))
  // Combine with existing output registers to register outputs for full cycle

  always @(posedge clk) begin
    if(reset) begin
      disc_r <= 1'b0;
      flag_r <= 1'b0;
    end else begin
      disc_r <= disc_w;
      flag_r <= flag_w;
      // err_r set in previous always block
      // err asserted when state==S7
    end
  end

  assign disc = disc_r;
  assign flag = flag_r;
  assign err  = err_r;

endmodule
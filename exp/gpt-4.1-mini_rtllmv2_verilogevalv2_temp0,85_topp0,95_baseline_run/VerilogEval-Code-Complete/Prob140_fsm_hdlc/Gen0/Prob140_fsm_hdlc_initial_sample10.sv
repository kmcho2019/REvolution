module TopModule (
  input clk,
  input reset,
  input in,
  output reg disc,
  output reg flag,
  output reg err
);

  // State encoding: count of consecutive ones after a leading zero
  // S0: 0 consecutive ones (previous bit zero)
  // S1: 1 one
  // S2: 2 ones
  // S3: 3 ones
  // S4: 4 ones
  // S5: 5 ones
  // S6: 6 ones
  // SERR: error state (7 or more ones)
  typedef enum reg [3:0] {
    S0=0, S1=1, S2=2, S3=3, S4=4, S5=5, S6=6, SERR=7
  } state_t;
  state_t state, next_state;

  always @(posedge clk) begin
    if (reset) begin
      state <= S0;  // On reset, assume previous bit zero
      disc <= 0;
      flag <= 0;
      err  <= 0;
    end else begin
      state <= next_state;

      // Outputs asserted one cycle after detecting condition
      // Conditions from previous state and input cause transition:
      // We'll assert outputs based on current state:
      // disc: when previous state was S5 and input was 0 (next_state=S0)
      // flag: when previous state was S6 and input was 0 (next_state=S0)
      // err : when in SERR state

      disc <= 0;
      flag <= 0;
      err  <= 0;

      case (state)
        S0: ; // no output
        S1: ; // no output
        S2: ; // no output
        S3: ; // no output
        S4: ; // no output
        S5: if (in == 0) disc <= 1; // disc if next input zero
        S6: if (in == 0) flag <= 1; // flag if next input zero
        SERR: err <= 1;
      endcase
    end
  end

  // Next state logic
  always @(*) begin
    case (state)
      S0: begin
        if (in == 1) next_state = S1;
        else next_state = S0;
      end
      S1: begin
        if (in == 1) next_state = S2;
        else next_state = S0;
      end
      S2: begin
        if (in == 1) next_state = S3;
        else next_state = S0;
      end
      S3: begin
        if (in == 1) next_state = S4;
        else next_state = S0;
      end
      S4: begin
        if (in == 1) next_state = S5;
        else next_state = S0;
      end
      S5: begin
        if (in == 1) next_state = S6;
        else next_state = S0;
      end
      S6: begin
        if (in == 1) next_state = SERR;
        else next_state = S0;
      end
      SERR: begin
        // Remain in error state until reset
        next_state = SERR;
      end
      default: next_state = S0;
    endcase
  end

endmodule
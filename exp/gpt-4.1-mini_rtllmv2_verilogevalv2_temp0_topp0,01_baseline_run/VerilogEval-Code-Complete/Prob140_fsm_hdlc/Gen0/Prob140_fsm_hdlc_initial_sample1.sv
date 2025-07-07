module TopModule (
  input clk,
  input reset,
  input in,
  output reg disc,
  output reg flag,
  output reg err
);

  // State encoding: number of consecutive 1s seen after a 0
  // 0: no consecutive 1s
  // 1..6: count of consecutive 1s
  // 7: error state (7 or more consecutive 1s)
  reg [3:0] state, next_state;

  // Moore outputs depend only on state
  // We will assert outputs for one cycle after condition detected,
  // so outputs are assigned based on next_state transitions.

  always @(posedge clk) begin
    if (reset) begin
      state <= 0;
      disc <= 0;
      flag <= 0;
      err <= 0;
    end else begin
      state <= next_state;

      // Default outputs
      disc <= 0;
      flag <= 0;
      err <= 0;

      // Outputs asserted for one cycle after condition detected
      // Conditions:
      // (1) disc: detected 5 consecutive 1s followed by 0 (state=5, in=0)
      // (2) flag: detected 6 consecutive 1s followed by 0 (state=6, in=0)
      // (3) err: detected 7 or more consecutive 1s (state=7)

      case (state)
        5: if (in == 0) disc <= 1;    // after seeing 5 ones, next 0 means discard bit
        6: if (in == 0) flag <= 1;    // after seeing 6 ones, next 0 means flag
        7: err <= 1;                  // error state: 7 or more ones
      endcase
    end
  end

  // Next state logic
  always @(*) begin
    case (state)
      0: next_state = in ? 1 : 0;
      1: next_state = in ? 2 : 0;
      2: next_state = in ? 3 : 0;
      3: next_state = in ? 4 : 0;
      4: next_state = in ? 5 : 0;
      5: next_state = in ? 6 : 0;
      6: next_state = in ? 7 : 0;
      7: next_state = in ? 7 : 0; // stay in error state if more ones
      default: next_state = 0;
    endcase
  end

endmodule
module TopModule (
  input clk,
  input reset,
  input in,
  output reg disc,
  output reg flag,
  output reg err
);

  // State encoding (number of consecutive 1s seen after last 0)
  typedef enum reg [3:0] {
    S0 = 4'd0, // no consecutive 1s
    S1 = 4'd1,
    S2 = 4'd2,
    S3 = 4'd3,
    S4 = 4'd4,
    S5 = 4'd5,
    S6 = 4'd6,
    S7 = 4'd7
  } state_t;

  reg [3:0] state, next_state;

  // Next state logic
  always @(*) begin
    case (state)
      S0: next_state = in ? S1 : S0;
      S1: next_state = in ? S2 : S0;
      S2: next_state = in ? S3 : S0;
      S3: next_state = in ? S4 : S0;
      S4: next_state = in ? S5 : S0;
      S5: next_state = in ? S6 : S0;
      S6: next_state = in ? S7 : S0;
      S7: next_state = in ? S7 : S0; // remain error on 1, reset on 0
      default: next_state = S0;
    endcase
  end

  // State update (synchronous reset)
  always @(posedge clk) begin
    if (reset) begin
      state <= S0;
    end else begin
      state <= next_state;
    end
  end

  // Outputs: asserted one cycle after detecting the pattern
  // Detect disc: 0111110 → five consecutive 1s followed by 0
  // This means at current cycle, state is S0 (due to 0 input), previous state was S5
  // We can detect disc at next_state == S0 && state == S5

  // Detect flag: 01111110 → six consecutive 1s followed by 0
  // next_state == S0 && state == S6

  // Detect err: seven or more 1s → state == S7

  reg disc_reg, flag_reg, err_reg;

  always @(posedge clk) begin
    if (reset) begin
      disc_reg <= 0;
      flag_reg <= 0;
      err_reg <= 0;
    end else begin
      // disc and flag are asserted for one cycle after condition detected
      disc_reg <= (next_state == S0) && (state == S5);
      flag_reg <= (next_state == S0) && (state == S6);
      err_reg <= (state == S7);
    end
  end

  assign disc = disc_reg;
  assign flag = flag_reg;
  assign err = err_reg;

endmodule
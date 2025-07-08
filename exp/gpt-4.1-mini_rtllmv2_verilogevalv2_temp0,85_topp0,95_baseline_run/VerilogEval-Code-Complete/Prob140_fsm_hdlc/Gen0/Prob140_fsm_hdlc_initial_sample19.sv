module TopModule (
  input clk,
  input reset,
  input in,
  output reg disc,
  output reg flag,
  output reg err
);

  // State encoding
  localparam S0 = 3'd0;
  localparam S1 = 3'd1;
  localparam S2 = 3'd2;
  localparam S3 = 3'd3;
  localparam S4 = 3'd4;
  localparam S5 = 3'd5;
  localparam S6 = 3'd6;
  localparam S7 = 3'd7; // 7 or more ones (error)

  reg [2:0] state, next_state;

  // Output registers to hold output signals for one cycle
  reg disc_next, flag_next, err_next;

  // State transition logic combinational
  always @(*) begin
    // Default next state is current state (hold)
    next_state = state;
    disc_next = 0;
    flag_next = 0;
    err_next = 0;

    case(state)
      S0: begin
        if (in)
          next_state = S1;
        else
          next_state = S0;
      end
      S1: begin
        if (in)
          next_state = S2;
        else
          next_state = S0;
      end
      S2: begin
        if (in)
          next_state = S3;
        else
          next_state = S0;
      end
      S3: begin
        if (in)
          next_state = S4;
        else
          next_state = S0;
      end
      S4: begin
        if (in)
          next_state = S5;
        else
          next_state = S0;
      end
      S5: begin
        if (in)
          next_state = S6;
        else begin
          // Sequence 0111110 detected (5 ones then 0)
          // disc must be asserted on next cycle (we are transitioning to S0)
          next_state = S0;
          disc_next = 1;
        end
      end
      S6: begin
        if (in)
          next_state = S7; // 7 or more ones => error
        else begin
          // Sequence 01111110 detected (6 ones then 0)
          // flag asserted on next cycle
          next_state = S0;
          flag_next = 1;
        end
      end
      S7: begin
        // Error state stays error if input=1
        // If input=0, reset count to S0 but still error was detected last cycle
        if (in)
          next_state = S7;
        else
          next_state = S0;
        // err asserted as long as we are in S7
        err_next = 1;
      end
      default: begin
        next_state = S0;
      end
    endcase
  end

  // Sequential logic: state and output registers
  always @(posedge clk) begin
    if (reset) begin
      state <= S0;
      disc <= 0;
      flag <= 0;
      err <= 0;
    end else begin
      state <= next_state;
      // Outputs asserted for one full cycle after detection
      disc <= disc_next;
      flag <= flag_next;
      // err asserted while in S7 state
      err <= (next_state == S7) ? 1'b1 : 1'b0;
    end
  end

endmodule
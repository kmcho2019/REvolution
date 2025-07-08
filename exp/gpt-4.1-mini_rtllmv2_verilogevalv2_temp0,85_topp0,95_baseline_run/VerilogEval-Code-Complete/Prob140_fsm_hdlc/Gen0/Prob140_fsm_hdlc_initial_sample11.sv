module TopModule (
  input clk,
  input reset,
  input in,
  output disc,
  output flag,
  output err
);
  // State encoding
  localparam S0 = 3'd0; // 0 consecutive ones
  localparam S1 = 3'd1; // 1 one
  localparam S2 = 3'd2; // 2 ones
  localparam S3 = 3'd3; // 3 ones
  localparam S4 = 3'd4; // 4 ones
  localparam S5 = 3'd5; // 5 ones
  localparam S6 = 3'd6; // 6 ones
  localparam S7 = 3'd7; // error state (>=7 ones)

  reg [2:0] state, next_state;

  // State register with synchronous reset
  always @(posedge clk) begin
    if (reset)
      state <= S0;
    else
      state <= next_state;
  end

  // Next state logic
  always @(*) begin
    case(state)
      S0: begin
        if (in == 1'b1)
          next_state = S1;
        else
          next_state = S0;
      end
      S1: begin
        if (in == 1'b1)
          next_state = S2;
        else
          next_state = S0;
      end
      S2: begin
        if (in == 1'b1)
          next_state = S3;
        else
          next_state = S0;
      end
      S3: begin
        if (in == 1'b1)
          next_state = S4;
        else
          next_state = S0;
      end
      S4: begin
        if (in == 1'b1)
          next_state = S5;
        else
          next_state = S0;
      end
      S5: begin
        if (in == 1'b1)
          next_state = S6;
        else
          next_state = S0;
      end
      S6: begin
        if (in == 1'b1)
          next_state = S7; // error state, 7 ones
        else
          next_state = S0;
      end
      S7: begin
        // stay in error if 1, else reset count if zero
        if (in == 1'b1)
          next_state = S7;
        else
          next_state = S0;
      end
      default: next_state = S0;
    endcase
  end

  // Output logic (Moore outputs depend only on state)
  // disc: asserted when previous input pattern was 0111110 -> disc output when state is S0 and last input caused transition from S5->S0 on input=0
  // flag: asserted when previous input pattern was 01111110 -> flag output when state is S0 and last input caused transition from S6->S0 on input=0
  // err: asserted in S7 state (>=7 ones)
  //
  // Because outputs depend only on state, and detection of disc and flag occur on zero input after 5 or 6 ones,
  // which leads to transition to S0. Thus we must remember previous state to generate disc or flag output.
  //
  // To achieve this, register previous state and input to identify these transitions.

  reg [2:0] prev_state;

  always @(posedge clk) begin
    if (reset)
      prev_state <= S0;
    else
      prev_state <= state;
  end

  wire disc_w;
  wire flag_w;
  wire err_w;

  assign disc_w = (state == S0) && (prev_state == S5) && (in == 1'b0);
  assign flag_w = (state == S0) && (prev_state == S6) && (in == 1'b0);
  assign err_w  = (state == S7);

  // Outputs registered for one clock cycle, update on posedge clk
  reg disc_r, flag_r, err_r;

  always @(posedge clk) begin
    if (reset) begin
      disc_r <= 1'b0;
      flag_r <= 1'b0;
      err_r  <= 1'b0;
    end else begin
      disc_r <= disc_w;
      flag_r <= flag_w;
      err_r  <= err_w;
    end
  end

  assign disc = disc_r;
  assign flag = flag_r;
  assign err  = err_r;

endmodule
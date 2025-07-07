module TopModule (
  input clk,
  input resetn,
  input x,
  input y,
  output reg f,
  output reg g
);

  // State encoding
  typedef enum logic [3:0] {
    A = 4'd0,       // Initial state after reset
    F_HIGH = 4'd1,  // f=1 for one clock cycle
    WAIT_X1 = 4'd2, // waiting for x=1 (first bit)
    WAIT_X0 = 4'd3, // waiting for x=0 (second bit)
    WAIT_X1_2 = 4'd4,// waiting for x=1 (third bit)
    G_HIGH_MONITOR_Y_0 = 4'd5, // g=1, monitor y first cycle
    G_HIGH_MONITOR_Y_1 = 4'd6, // g=1, monitor y second cycle
    G_HIGH_PERM = 4'd7,        // g=1 permanently
    G_LOW_PERM = 4'd8          // g=0 permanently
  } state_t;

  state_t state, next_state;

  // Sequential state and output update
  always @(posedge clk) begin
    if (!resetn) begin
      state <= A;
      f <= 1'b0;
      g <= 1'b0;
    end else begin
      state <= next_state;
      // Outputs depend on next_state
      case (next_state)
        F_HIGH: f <= 1'b1;
        default: f <= 1'b0;
      endcase

      case (next_state)
        G_HIGH_MONITOR_Y_0,
        G_HIGH_MONITOR_Y_1,
        G_HIGH_PERM: g <= 1'b1;
        G_LOW_PERM: g <= 1'b0;
        default: g <= 1'b0;
      endcase
    end
  end

  // Next state logic
  always @(*) begin
    next_state = state; // default hold

    case (state)
      A: begin
        // Wait for resetn de-asserted, then next clock go to F_HIGH
        if (resetn)
          next_state = F_HIGH;
        else
          next_state = A;
      end

      F_HIGH: begin
        // After one cycle of f=1, start monitoring x sequence
        next_state = WAIT_X1;
      end

      WAIT_X1: begin
        // Wait for x=1 to start sequence
        if (x == 1'b1)
          next_state = WAIT_X0;
        else
          next_state = WAIT_X1; // keep waiting
      end

      WAIT_X0: begin
        // Wait for x=0 after first 1
        if (x == 1'b0)
          next_state = WAIT_X1_2;
        else if (x == 1'b1)
          next_state = WAIT_X0; // stay here if x=1 (sequence broken, but wait for 0)
        else
          next_state = WAIT_X0;
      end

      WAIT_X1_2: begin
        // Wait for x=1 to complete sequence 1,0,1
        if (x == 1'b1)
          next_state = G_HIGH_MONITOR_Y_0;
        else if (x == 1'b0)
          next_state = WAIT_X1; // restart sequence if x=0
        else
          next_state = WAIT_X1_2;
      end

      G_HIGH_MONITOR_Y_0: begin
        // g=1, monitor y first cycle
        if (y == 1'b1)
          next_state = G_HIGH_PERM;
        else
          next_state = G_HIGH_MONITOR_Y_1;
      end

      G_HIGH_MONITOR_Y_1: begin
        // g=1, monitor y second cycle
        if (y == 1'b1)
          next_state = G_HIGH_PERM;
        else
          next_state = G_LOW_PERM;
      end

      G_HIGH_PERM: begin
        // g=1 permanently until reset
        next_state = G_HIGH_PERM;
      end

      G_LOW_PERM: begin
        // g=0 permanently until reset
        next_state = G_LOW_PERM;
      end

      default: next_state = A;
    endcase
  end

endmodule
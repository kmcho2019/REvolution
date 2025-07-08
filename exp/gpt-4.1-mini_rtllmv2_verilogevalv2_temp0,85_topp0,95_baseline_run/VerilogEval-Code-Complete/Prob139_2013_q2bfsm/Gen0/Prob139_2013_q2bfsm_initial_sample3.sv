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
    STATE_A        = 4'd0,  // Initial state, f=0,g=0
    STATE_F_ONE    = 4'd1,  // f=1 for one clock cycle
    STATE_WAIT_X1  = 4'd2,  // Waiting for x=1 (start sequence)
    STATE_WAIT_X0  = 4'd3,  // Waiting for x=0 (2nd in sequence)
    STATE_WAIT_X1_2= 4'd4,  // Waiting for x=1 (3rd in sequence)
    STATE_G_ONE    = 4'd5,  // g=1, monitoring y (clock 0)
    STATE_Y_WAIT_1 = 4'd6,  // g=1, 1st cycle waiting for y=1
    STATE_Y_WAIT_2 = 4'd7,  // g=1, 2nd cycle waiting for y=1
    STATE_G_ONE_PERM = 4'd8,// g=1 permanently
    STATE_G_ZERO_PERM=4'd9  // g=0 permanently
  } state_t;

  state_t state, next_state;

  // Sequential state transition
  always @(posedge clk) begin
    if (~resetn) begin
      state <= STATE_A;
    end else begin
      state <= next_state;
    end
  end

  // Next state logic and output logic
  always @(*) begin
    // Default output and next state values
    f = 1'b0;
    g = 1'b0;
    next_state = state;

    case(state)
      STATE_A: begin
        // Wait for resetn de-asserted, f=0,g=0
        // Actually resetn synchronous active low, so if resetn=1 FSM moves on next clock
        // But this is combinational logic so just stay here until resetn=1 (handled in sequential)
        f = 1'b0;
        g = 1'b0;
        if (resetn) begin
          next_state = STATE_F_ONE;
        end else begin
          next_state = STATE_A;
        end
      end

      STATE_F_ONE: begin
        // f=1 for one cycle
        f = 1'b1;
        g = 1'b0;
        next_state = STATE_WAIT_X1;
      end

      STATE_WAIT_X1: begin
        // Wait for x=1 to start sequence
        f = 1'b0;
        g = 1'b0;
        if (x == 1'b1) begin
          next_state = STATE_WAIT_X0;
        end else begin
          next_state = STATE_WAIT_X1;
        end
      end

      STATE_WAIT_X0: begin
        // Wait for x=0 (2nd in sequence)
        f = 1'b0;
        g = 1'b0;
        if (x == 1'b0) begin
          next_state = STATE_WAIT_X1_2;
        end else if (x == 1'b1) begin
          // Sequence broken, restart waiting for 1
          next_state = STATE_WAIT_X1;
        end else begin
          next_state = STATE_WAIT_X0;
        end
      end

      STATE_WAIT_X1_2: begin
        // Wait for x=1 (3rd in sequence)
        f = 1'b0;
        g = 1'b0;
        if (x == 1'b1) begin
          // Sequence detected, set g=1 next cycle
          next_state = STATE_G_ONE;
        end else begin
          // Sequence broken, restart waiting for 1
          next_state = STATE_WAIT_X1;
        end
      end

      STATE_G_ONE: begin
        // Set g=1, monitor y, start counting cycles for y
        f = 1'b0;
        g = 1'b1;
        // On next cycle start waiting for y to be 1 within two cycles
        next_state = STATE_Y_WAIT_1;
      end

      STATE_Y_WAIT_1: begin
        f = 1'b0;
        g = 1'b1;
        if (y == 1'b1) begin
          // y=1 within first cycle, maintain g=1 permanently
          next_state = STATE_G_ONE_PERM;
        end else begin
          // wait one more cycle
          next_state = STATE_Y_WAIT_2;
        end
      end

      STATE_Y_WAIT_2: begin
        f = 1'b0;
        g = 1'b1;
        if (y == 1'b1) begin
          // y=1 within second cycle, maintain g=1 permanently
          next_state = STATE_G_ONE_PERM;
        end else begin
          // y not detected in two cycles, set g=0 permanently
          next_state = STATE_G_ZERO_PERM;
        end
      end

      STATE_G_ONE_PERM: begin
        // g=1 permanently until reset
        f = 1'b0;
        g = 1'b1;
        next_state = STATE_G_ONE_PERM;
      end

      STATE_G_ZERO_PERM: begin
        // g=0 permanently until reset
        f = 1'b0;
        g = 1'b0;
        next_state = STATE_G_ZERO_PERM;
      end

      default: begin
        f = 1'b0;
        g = 1'b0;
        next_state = STATE_A;
      end
    endcase
  end

endmodule
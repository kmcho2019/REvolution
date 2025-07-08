module TopModule (
  input clk,
  input resetn,
  input x,
  input y,
  output reg f,
  output reg g
);

  // State encoding
  typedef enum logic [2:0] {
    A = 3'd0, // reset state
    B = 3'd1, // f=1 for one cycle
    C0 = 3'd2, // waiting for x=1 (1st of pattern)
    C1 = 3'd3, // got x=1, waiting for x=0 (2nd)
    C2 = 3'd4, // got x=1,0, waiting for x=1 (3rd)
    D = 3'd5,  // g=1, monitoring y for 2 cycles
    E = 3'd6,  // g=1 permanently (y=1 detected)
    F = 3'd7   // g=0 permanently (y=1 not detected in 2 cycles)
  } state_t;

  state_t state, next_state;

  reg [1:0] y_monitor_count; // counts cycles since entering D state

  // State register with synchronous active-low reset
  always @(posedge clk) begin
    if (!resetn) begin
      state <= A;
      y_monitor_count <= 2'd0;
    end else begin
      state <= next_state;
      // Update y_monitor_count only in D state
      if (state == D) begin
        y_monitor_count <= y_monitor_count + 2'd1;
      end else begin
        y_monitor_count <= 2'd0;
      end
    end
  end

  // Next state logic and output logic
  always @(*) begin
    // Defaults
    next_state = state;
    f = 1'b0;
    g = 1'b0;

    case(state)
      A: begin
        // In reset, f=0,g=0; wait for resetn deassertion (handled by state register)
        f = 1'b0;
        g = 1'b0;
        if (resetn) begin
          next_state = B; // move to B on next clk after resetn deasserted
        end else begin
          next_state = A;
        end
      end

      B: begin
        // f=1 one cycle, then move to pattern detection
        f = 1'b1;
        g = 1'b0;
        next_state = C0;
      end

      C0: begin
        // Wait for x=1 to start pattern
        f = 1'b0;
        g = 1'b0;
        if (x == 1'b1) next_state = C1;
        else next_state = C0;
      end

      C1: begin
        // Expect x=0 next cycle
        f = 1'b0;
        g = 1'b0;
        if (x == 1'b0) next_state = C2;
        else if (x == 1'b1) next_state = C1; // stay if repeat 1s, wait for 0
        else next_state = C0; // else restart pattern
      end

      C2: begin
        // Expect x=1 next cycle to complete pattern
        f = 1'b0;
        g = 1'b0;
        if (x == 1'b1) next_state = D; // pattern detected
        else if (x == 1'b0) next_state = C0; // restart pattern if mismatch
        else next_state = C0;
      end

      D: begin
        // g=1, monitor y for up to 2 cycles
        f = 1'b0;
        g = 1'b1;
        // If y=1 at any cycle, go to E (permanent g=1)
        if (y == 1'b1) begin
          next_state = E;
        end else if (y_monitor_count == 2'd1) begin
          // if we have already waited 2 cycles (count starts from zero in D)
          next_state = F;
        end else begin
          next_state = D;
        end
      end

      E: begin
        // g=1 permanently until reset
        f = 1'b0;
        g = 1'b1;
        next_state = E;
      end

      F: begin
        // g=0 permanently until reset
        f = 1'b0;
        g = 1'b0;
        next_state = F;
      end

      default: begin
        // safety fallback: go to reset state
        f = 1'b0;
        g = 1'b0;
        next_state = A;
      end
    endcase
  end

endmodule
module TopModule (
  input clk,
  input resetn,
  input x,
  input y,
  output reg f,
  output reg g
);

  // Define states
  typedef enum reg [3:0] {
    A = 4'd0,    // Reset state
    B = 4'd1,    // Output f=1 for one cycle after reset deasserted
    C0 = 4'd2,   // Waiting for first x=1
    C1 = 4'd3,   // Got x=1, waiting for x=0
    C2 = 4'd4,   // Got x=1,0, waiting for x=1
    D = 4'd5,    // Output g=1 one cycle after detecting sequence
    E0 = 4'd6,   // Monitor y for up to 1st cycle
    E1 = 4'd7,   // Monitor y for 2nd cycle or permanent g=1
    F = 4'd8     // Permanent g=0 (failure)
  } state_t;

  state_t state, next_state;

  // State transition logic
  always @(posedge clk) begin
    if (!resetn) begin
      state <= A;
    end else begin
      state <= next_state;
    end
  end

  // Next state combinational logic
  always @(*) begin
    // Default next state is current state
    next_state = state;

    case (state)
      A: begin
        if (resetn) // reset released
          next_state = B;
      end

      B: begin
        // After outputting f=1 one cycle, go to C0 to monitor x
        next_state = C0;
      end

      C0: begin
        // Waiting for x=1 to start sequence
        if (x == 1'b1)
          next_state = C1;
        else
          next_state = C0; // stay waiting for first 1
      end

      C1: begin
        // Got first 1, waiting for 0
        if (x == 1'b0)
          next_state = C2;
        else if (x == 1'b1)
          next_state = C1; // still waiting for 0, repeated 1 resets nothing
        else
          next_state = C0; // unclear but fallback to waiting for first 1
      end

      C2: begin
        // Got 1,0; waiting for final 1
        if (x == 1'b1)
          next_state = D;
        else if (x == 1'b0)
          next_state = C0; // restart sequence if zero appears again
        else
          next_state = C0;
      end

      D: begin
        // Output g=1 one cycle, then monitor y up to two cycles
        next_state = E0;
      end

      E0: begin
        // Check y first cycle monitoring
        if (y == 1'b1)
          next_state = E1; // y detected, permanent g=1
        else
          next_state = E1; // second cycle monitoring
      end

      E1: begin
        // Second cycle monitoring y
        if (y == 1'b1)
          next_state = E1; // remain here, permanent g=1
        else
          next_state = F;  // y not detected in two cycles, permanent g=0
      end

      F: begin
        // Permanent g=0 state until reset
        next_state = F;
      end

      default: next_state = A;
    endcase
  end

  // Output logic
  always @(posedge clk) begin
    if (!resetn) begin
      f <= 1'b0;
      g <= 1'b0;
    end else begin
      case (state)
        A: begin
          f <= 1'b0;
          g <= 1'b0;
        end

        B: begin
          f <= 1'b1;  // output f=1 for one clock cycle
          g <= 1'b0;
        end

        C0, C1, C2: begin
          f <= 1'b0;
          g <= 1'b0;
        end

        D: begin
          f <= 1'b0;
          g <= 1'b1;  // output g=1 for one clock cycle after sequence detected
        end

        E0, E1: begin
          f <= 1'b0;
          g <= 1'b1;  // maintain g=1 while monitoring y
        end

        F: begin
          f <= 1'b0;
          g <= 1'b0;  // permanent g=0 after failed y detection
        end

        default: begin
          f <= 1'b0;
          g <= 1'b0;
        end
      endcase
    end
  end

endmodule
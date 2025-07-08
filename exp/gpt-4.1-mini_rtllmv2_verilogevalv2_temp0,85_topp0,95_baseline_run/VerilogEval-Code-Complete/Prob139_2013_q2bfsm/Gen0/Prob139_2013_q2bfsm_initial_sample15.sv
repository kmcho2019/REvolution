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
    A = 3'd0, // Reset state
    B = 3'd1, // Output f=1 one cycle
    C = 3'd2, // Monitor x sequence 1,0,1
    D = 3'd3, // g=1, monitor y for 2 cycles
    E = 3'd4, // Permanent g=1
    F = 3'd5  // Permanent g=0
  } state_t;

  state_t state, next_state;

  // For sequence detection in C
  // We track progress through the sequence "1,0,1"
  // sequence_step = 0: waiting for first '1'
  // sequence_step = 1: got first '1', wait for '0'
  // sequence_step = 2: got '0', wait for '1'
  // sequence_step = 3: sequence complete
  reg [1:0] sequence_step;

  // For monitoring y in D state
  reg [1:0] y_count; // count clock cycles monitoring y (0 to 2)

  // Sequential logic: state update and outputs
  always @(posedge clk) begin
    if (~resetn) begin
      state <= A;
      sequence_step <= 2'd0;
      y_count <= 2'd0;
      f <= 1'b0;
      g <= 1'b0;
    end else begin
      state <= next_state;

      // Outputs default to 0; set explicitly in states
      f <= 1'b0;

      case (state)
        A: begin
          // Hold outputs at 0
          f <= 1'b0;
          g <= 1'b0;
          // Clear sequence and counters on reset state
          sequence_step <= 2'd0;
          y_count <= 2'd0;
        end

        B: begin
          // Output f=1 for one clock cycle
          f <= 1'b1;
          g <= 1'b0;
          // Clear sequence tracking since about to start monitoring x
          sequence_step <= 2'd0;
          y_count <= 2'd0;
        end

        C: begin
          f <= 1'b0;
          g <= 1'b0;
          // Sequence detection logic
          case (sequence_step)
            2'd0: // waiting for first '1'
              if (x == 1'b1)
                sequence_step <= 2'd1;
              else
                sequence_step <= 2'd0;
            2'd1: // got '1', waiting for '0'
              if (x == 1'b0)
                sequence_step <= 2'd2;
              else if (x == 1'b1)
                sequence_step <= 2'd1; // stay waiting for next 0
              else
                sequence_step <= 2'd0;
            2'd2: // got '0', waiting for '1'
              if (x == 1'b1)
                sequence_step <= 2'd3; // sequence complete
              else if (x == 1'b0)
                sequence_step <= 2'd2; // wait for 1
              else
                sequence_step <= 2'd0;
            default: // Should not be here
              sequence_step <= 2'd0;
          endcase
          y_count <= 2'd0; // reset y_count in C state
        end

        D: begin
          f <= 1'b0;
          g <= 1'b1;

          // Monitor y for at most two clock cycles
          if (y == 1'b1) begin
            // If y=1 within 2 clocks, stay in permanent g=1 state
            y_count <= y_count; // no need to update counter
          end else begin
            // Increment count only if y=0
            y_count <= y_count + 1'b1;
          end
        end

        E: begin
          // Permanent g=1 state
          f <= 1'b0;
          g <= 1'b1;
        end

        F: begin
          // Permanent g=0 state
          f <= 1'b0;
          g <= 1'b0;
        end

        default: begin
          f <= 1'b0;
          g <= 1'b0;
          sequence_step <= 2'd0;
          y_count <= 2'd0;
        end
      endcase
    end
  end

  // Next state logic combinational
  always @(*) begin
    next_state = state; // default hold

    case (state)
      A: begin
        if (resetn) begin
          // resetn de-asserted, move to B next cycle
          next_state = B;
        end else begin
          next_state = A;
        end
      end

      B: begin
        // After outputting f=1 one cycle, go to C
        next_state = C;
      end

      C: begin
        // Wait for sequence_step to reach 3 (sequence complete)
        if (sequence_step == 2'd3)
          next_state = D;
        else
          next_state = C;
      end

      D: begin
        if (y == 1'b1) begin
          // y detected within monitoring period, go permanent g=1
          next_state = E;
        end else if (y_count >= 2'd2) begin
          // y not detected in 2 cycles, go permanent g=0
          next_state = F;
        end else begin
          next_state = D; // keep monitoring
        end
      end

      E: begin
        // Permanent g=1 until reset
        if (~resetn)
          next_state = A;
        else
          next_state = E;
      end

      F: begin
        // Permanent g=0 until reset
        if (~resetn)
          next_state = A;
        else
          next_state = F;
      end

      default: next_state = A;
    endcase
  end

endmodule
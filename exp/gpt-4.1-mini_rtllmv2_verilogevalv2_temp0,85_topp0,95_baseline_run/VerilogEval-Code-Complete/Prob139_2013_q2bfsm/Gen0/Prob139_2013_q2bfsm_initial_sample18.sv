module TopModule (
  input clk,
  input resetn,
  input x,
  input y,
  output reg f,
  output reg g
);

  // State encoding
  typedef enum reg [2:0] {
    A = 3'b000, // reset state
    B = 3'b001, // output f=1 one clock
    C = 3'b010, // detect x pattern 1,0,1
    D = 3'b011, // g=1, monitor y up to 2 cycles
    E = 3'b100  // g=0 permanently
  } state_t;

  reg [2:0] state, next_state;

  // For pattern detection: track x sequence
  reg [1:0] x_pattern_state; // 0: waiting for 1, 1: waiting for 0, 2: waiting for 1

  // For y monitoring in state D
  reg [1:0] y_counter; // count cycles since entering D

  // Next state logic and outputs
  always @(*) begin
    // Default assignments
    next_state = state;
    f = 0;
    g = 0;

    case(state)
      A: begin
        // stay in A while resetn=0
        // When resetn=1, go to B next clock
        f = 0;
        g = 0;
        if (resetn == 1'b1)
          next_state = B;
        else
          next_state = A;
      end
      B: begin
        // output f=1 for one clock cycle then move to C
        f = 1;
        g = 0;
        next_state = C;
      end
      C: begin
        // f=0, g=0
        f = 0;
        g = 0;
        // Detect sequence 1,0,1 on x over three consecutive cycles
        // Use x_pattern_state as a mini state machine:
        // 0: waiting for 1
        // 1: waiting for 0
        // 2: waiting for 1
        //
        // If sequence detected then next_state = D else stay in C

        case(x_pattern_state)
          2'd0: begin
            if (x == 1'b1)
              next_state = C; // remain in C and advance pattern state in sequential block
            else
              next_state = C;
          end
          2'd1: begin
            if (x == 1'b0)
              next_state = C;
            else if (x == 1'b1)
              next_state = C; // reset pattern state to 0 actually handled in sequential block
          end
          2'd2: begin
            if (x == 1'b1)
              next_state = D;
            else
              next_state = C; // restart pattern detection if mismatch
          end
          default: next_state = C;
        endcase
      end
      D: begin
        // g=1, f=0
        f = 0;
        g = 1;
        // monitor y for at most 2 cycles
        // if y=1 stay in D
        // else if counter expired go to E
        // else remain in D

        if (y == 1'b1) begin
          // y=1 detected, stay in D permanently
          next_state = D;
        end else begin
          // y not 1, check counter in sequential block to move to E or remain
          next_state = D;
        end
      end
      E: begin
        // g=0 permanently
        f = 0;
        g = 0;
        next_state = E;
      end
      default: begin
        f = 0;
        g = 0;
        next_state = A;
      end
    endcase
  end

  // Sequential logic for state, x_pattern_state and y_counter
  always @(posedge clk) begin
    if (resetn == 1'b0) begin
      state <= A;
      x_pattern_state <= 2'd0;
      y_counter <= 2'd0;
    end else begin
      state <= next_state;

      // Update x_pattern_state only in state C
      if (next_state == C) begin
        case(x_pattern_state)
          2'd0: begin
            if (x == 1'b1)
              x_pattern_state <= 2'd1;
            else
              x_pattern_state <= 2'd0;
          end
          2'd1: begin
            if (x == 1'b0)
              x_pattern_state <= 2'd2;
            else if (x == 1'b1)
              x_pattern_state <= 2'd1; // remain waiting for 0
            else
              x_pattern_state <= 2'd0;
          end
          2'd2: begin
            if (x == 1'b1)
              x_pattern_state <= 2'd0; // will go to D next cycle
            else
              x_pattern_state <= 2'd0; // restart pattern detection
          end
          default: x_pattern_state <= 2'd0;
        endcase
      end else begin
        x_pattern_state <= 2'd0; // reset pattern state outside C
      end

      // Handle y_counter in state D
      if (next_state == D) begin
        if (y == 1'b1) begin
          // y detected, stay in D indefinitely, reset counter
          y_counter <= 2'd0;
        end else begin
          // y not detected, increment counter up to 2
          if (y_counter < 2'd2)
            y_counter <= y_counter + 1'b1;
          else
            y_counter <= y_counter;
        end
      end else begin
        y_counter <= 2'd0;
      end

      // Transition from D to E if y not detected within 2 cycles
      if (state == D && next_state == D && y_counter == 2'd2 && y == 1'b0) begin
        state <= E; // override state to E immediately
      end
    end
  end

endmodule
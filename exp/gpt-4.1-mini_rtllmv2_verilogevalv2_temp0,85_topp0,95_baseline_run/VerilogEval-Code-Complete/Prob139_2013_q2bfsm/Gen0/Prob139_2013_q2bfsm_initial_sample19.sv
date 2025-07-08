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
    A = 3'd0, // initial state, f=0,g=0
    B = 3'd1, // f=1 for one cycle after reset de-assert
    C1 = 3'd2, // wait for x=1 (first in sequence)
    C2 = 3'd3, // wait for x=0 (second in sequence)
    C3 = 3'd4, // wait for x=1 (third in sequence)
    D = 3'd5, // set g=1 for one cycle after sequence detected
    E = 3'd6, // monitor y for up to 2 clock cycles while g=1
    F = 3'd7  // permanent g=1
  } state_t;

  state_t state, next_state;

  reg [1:0] y_counter; // counts up to 2 cycles in state E

  // Next state and output logic combinational block
  always @(*) begin
    // Defaults
    next_state = state;
    f = 1'b0;
    g = 1'b0;

    case(state)
      A: begin
        // Outputs f=0,g=0
        // Wait for resetn de-asserted (handled in sequential block)
        // next state depends on resetn (sequential)
        // here just stay in A if resetn==0
        f = 1'b0;
        g = 1'b0;
      end

      B: begin
        // f=1 one cycle
        f = 1'b1;
        g = 1'b0;
      end

      C1: begin
        f = 1'b0;
        g = 1'b0;
      end

      C2: begin
        f = 1'b0;
        g = 1'b0;
      end

      C3: begin
        f = 1'b0;
        g = 1'b0;
      end

      D: begin
        f = 1'b0;
        g = 1'b1; // g=1 for one cycle after seq detected
      end

      E: begin
        f = 1'b0;
        g = 1'b1; // maintain g=1 while monitoring y
      end

      F: begin
        f = 1'b0;
        g = 1'b1; // permanent g=1
      end

      default: begin
        f = 1'b0;
        g = 1'b0;
      end
    endcase
  end

  // Sequential logic: state transition and output registers
  always @(posedge clk) begin
    if (~resetn) begin
      // synchronous active low reset: go to state A
      state <= A;
      y_counter <= 2'd0;
    end else begin
      case(state)
        A: begin
          // After reset de-asserted and clk rising edge, go to B
          state <= B;
          y_counter <= 2'd0;
        end

        B: begin
          // After outputting f=1 for one cycle, move to monitor x seq
          state <= C1;
          y_counter <= 2'd0;
        end

        C1: begin
          // Wait for x=1 to start sequence, else remain in C1
          if (x == 1'b1)
            state <= C2;
          else
            state <= C1;
          y_counter <= 2'd0;
        end

        C2: begin
          // Wait for x=0, else if x=1 restart sequence (since sequence is 1,0,1)
          if (x == 1'b0)
            state <= C3;
          else if (x == 1'b1)
            state <= C2; // stay here, x=1 again, but sequence requires 0 here, so stay
          else
            state <= C1; // else revert to start sequence
          y_counter <= 2'd0;
        end

        C3: begin
          // Wait for x=1, else if x=0 restart sequence
          if (x == 1'b1)
            state <= D;
          else
            state <= C1;
          y_counter <= 2'd0;
        end

        D: begin
          // output g=1 for one cycle, then monitor y
          state <= E;
          y_counter <= 2'd0;
        end

        E: begin
          // monitor y input for at most 2 cycles
          if (y == 1'b1) begin
            state <= F; // permanent g=1
            y_counter <= 2'd0;
          end else if (y_counter == 2'd1) begin
            // y not 1 after 2 cycles, turn g=0 permanently (go back to A)
            state <= A;
            y_counter <= 2'd0;
          end else begin
            // increment counter, stay in E
            state <= E;
            y_counter <= y_counter + 1'b1;
          end
        end

        F: begin
          // permanent g=1 until reset
          state <= F;
          y_counter <= 2'd0;
        end

        default: begin
          state <= A;
          y_counter <= 2'd0;
        end
      endcase
    end
  end

endmodule
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
    A = 3'd0,
    B = 3'd1,
    C0 = 3'd2, // waiting for x=1 first in pattern detector
    C1 = 3'd3, // waiting for x=0 second in pattern detector
    C2 = 3'd4, // waiting for x=1 third in pattern detector
    D = 3'd5,  // g=1, monitor y for 2 cycles
    F = 3'd6,  // permanent g=1
    G = 3'd7   // permanent g=0
  } state_t;

  state_t state, next_state;

  reg [1:0] y_count; // count up to 2 for y monitoring in D state

  // State transitions and output logic
  always @(posedge clk) begin
    if (!resetn) begin
      state <= A;
      f <= 0;
      g <= 0;
      y_count <= 2'd0;
    end else begin
      state <= next_state;

      // Default outputs
      f <= 0;

      case (next_state)
        B: f <= 1;   // one clock cycle with f=1
        D: g <= 1;
        F: g <= 1;
        G: g <= 0;
        default: begin
          // maintain g as is only in F or G, else reset to 0
          if (next_state != F && next_state != G)
            g <= 0;
        end
      endcase

      // y_count update
      if (state == D) begin
        if (y == 1 || y_count == 2) begin
          y_count <= y_count; // freeze count if y=1 or count=2
        end else begin
          y_count <= y_count + 1;
        end
      end else begin
        y_count <= 2'd0;
      end
    end
  end

  // Next state logic combinational
  always @(*) begin
    next_state = state;

    case (state)
      A: begin
        if (resetn)
          next_state = B;
        else
          next_state = A;
      end

      B: begin
        // after one cycle with f=1, go to x pattern detect start
        next_state = C0;
      end

      // Pattern detection states for x=1,0,1 sequence
      C0: begin
        if (x == 1)
          next_state = C1;
        else
          next_state = C0; // keep waiting for first 1
      end

      C1: begin
        if (x == 0)
          next_state = C2;
        else if (x == 1)
          next_state = C1; // stay here if x=1 again (wait for 0)
        else
          next_state = C0; // reset pattern if x not 0 or 1 (should not happen as input is 1 bit)
      end

      C2: begin
        if (x == 1)
          next_state = D; // pattern detected
        else if (x == 0)
          next_state = C0; // restart pattern detection from first 1
        else
          next_state = C0;
      end

      D: begin
        // g=1, monitor y for max two cycles to see if y=1
        // if y=1 within 2 cycles go to F else after 2 cycles go to G
        if (y == 1)
          next_state = F; // permanent g=1
        else if (y_count == 2)
          next_state = G; // permanent g=0
        else
          next_state = D;
      end

      F: begin
        // permanent g=1 until reset
        if (!resetn)
          next_state = A;
        else
          next_state = F;
      end

      G: begin
        // permanent g=0 until reset
        if (!resetn)
          next_state = A;
        else
          next_state = G;
      end

      default: next_state = A;
    endcase
  end

endmodule
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
    C0 = 3'd2, // monitoring sequence step 0
    C1 = 3'd3, // sequence step 1 detected (x=1)
    C2 = 3'd4, // sequence step 2 detected (x=1,0)
    D = 3'd5,  // g=1, monitoring y for 2 cycles
    E = 3'd6   // g=0 permanently
  } state_t;

  state_t state, next_state;
  reg [1:0] y_count;  // to count up to 2 cycles in D state

  // Sequential logic: state and y_count update
  always @(posedge clk) begin
    if (!resetn) begin
      state <= A;
      y_count <= 2'd0;
    end else begin
      state <= next_state;
      if (state == D) begin
        if (y == 1'b0 && y_count < 2)
          y_count <= y_count + 1;
        else if (y == 1'b1)
          y_count <= 2'd0; // reset counter if y=1 found
      end else begin
        y_count <= 2'd0;
      end
    end
  end

  // Combinational logic: next state and output logic
  always @(*) begin
    // default outputs
    f = 1'b0;
    g = 1'b0;
    next_state = state;

    case (state)
      A: begin
        // stay in A while resetn==0
        // when resetn de-asserted, move to B next clock
        if (resetn)
          next_state = B;
      end

      B: begin
        // output f=1 for 1 clock cycle
        f = 1'b1;
        // then move to C0 to start monitoring x sequence
        next_state = C0;
      end

      // States C0, C1, C2 track sequence 1,0,1 on x
      C0: begin
        // waiting for first x=1
        if (x == 1'b1)
          next_state = C1;
        else
          next_state = C0;
      end

      C1: begin
        // waiting for x=0 next
        if (x == 1'b0)
          next_state = C2;
        else if (x == 1'b1)
          next_state = C1; // stay if repeated 1, to handle consecutive 1s
        else
          next_state = C0; // if x != 0 or 1 (shouldn't happen), restart
      end

      C2: begin
        // waiting for x=1 to complete sequence
        if (x == 1'b1)
          next_state = D; // sequence detected, set g=1 in D
        else if (x == 1'b0)
          next_state = C0; // restart searching sequence if zero again
        else
          next_state = C0; // safety restart
      end

      D: begin
        // maintain g=1 and monitor y for at most 2 clock cycles
        g = 1'b1;

        if (y == 1'b1) begin
          // y=1 within 2 cycles, stay in D permanently
          next_state = D;
        end else begin
          // y=0, check how many cycles passed
          if (y_count == 2)
            next_state = E; // timeout, go to E permanently g=0
          else
            next_state = D; // still waiting
        end
      end

      E: begin
        // g=0 permanently until reset
        g = 1'b0;
        next_state = E;
      end

      default: begin
        next_state = A;
      end
    endcase
  end

endmodule
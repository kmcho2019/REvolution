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
    A = 3'd0, // Reset state, f=0, g=0
    B = 3'd1, // f=1 for one cycle after reset
    C = 3'd2, // Monitor x for 1,0,1 sequence
    D = 3'd3, // g=1, monitor y for up to 2 cycles
    E = 3'd4  // g=0 permanently (after y not detected)
  } state_t;

  reg [2:0] state, next_state;

  // To detect sequence 1,0,1 on x input over three cycles, we can create sub-states or counters:
  // We'll implement a small sequence detector with a separate reg:
  // seq_state encodes the progress of the pattern detection:
  // 0 = waiting for 1
  // 1 = got 1, waiting for 0
  // 2 = got 1,0 waiting for 1
  reg [1:0] seq_state;

  // Counter for y monitoring in state D
  reg [1:0] y_count;

  // Sequential state transitions and registers
  always @(posedge clk) begin
    if (!resetn) begin
      state <= A;
      f <= 1'b0;
      g <= 1'b0;
      seq_state <= 2'd0;
      y_count <= 2'd0;
    end else begin
      state <= next_state;

      case(state)
        A: begin
          f <= 1'b0;
          g <= 1'b0;
          seq_state <= 2'd0;
          y_count <= 2'd0;
        end
        B: begin
          f <= 1'b1;   // f=1 for one cycle here
          g <= 1'b0;
          seq_state <= 2'd0;
          y_count <= 2'd0;
        end
        C: begin
          f <= 1'b0;
          g <= 1'b0;
          y_count <= 2'd0;
          // Sequence detection logic
          case (seq_state)
            2'd0: if (x == 1'b1) seq_state <= 2'd1; // got first 1
                  else seq_state <= 2'd0; // stay waiting for 1
            2'd1: if (x == 1'b0) seq_state <= 2'd2; // got 0 after 1
                  else if (x == 1'b1) seq_state <= 2'd1; // still 1, stay in 1
                  else seq_state <= 2'd0; // reset otherwise
            2'd2: if (x == 1'b1) seq_state <= 2'd3; // got full sequence
                  else if (x == 1'b0) seq_state <= 2'd0; // failed, reset
                  else seq_state <= 2'd0;
            default: seq_state <= 2'd0;
          endcase
        end
        D: begin
          f <= 1'b0;
          g <= 1'b1;
          // monitor y for up to 2 cycles
          if (y_count < 2) begin
            y_count <= y_count + 1;
          end
        end
        E: begin
          f <= 1'b0;
          g <= 1'b0;
          y_count <= y_count; // hold value
        end
        default: begin
          f <= 1'b0;
          g <= 1'b0;
          seq_state <= 2'd0;
          y_count <= 2'd0;
        end
      endcase
    end
  end

  // Next state logic
  always @(*) begin
    next_state = state;
    case(state)
      A: if (resetn) next_state = B;
      B: next_state = C;
      C: begin
        // Once sequence 1,0,1 detected, move to D
        if (seq_state == 2'd3)
          next_state = D;
        else
          next_state = C;
      end
      D: begin
        // If y==1 within 2 cycles, stay in D indefinitely
        // Otherwise if two cycles passed and y never ==1, go to E
        if (y == 1'b1)
          next_state = D;
        else if (y_count >= 2)
          next_state = E;
        else
          next_state = D;
      end
      E: next_state = E;
      default: next_state = A;
    endcase
  end

endmodule
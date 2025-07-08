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
    A  = 3'b000,
    B  = 3'b001,
    C0 = 3'b010,
    C1 = 3'b011,
    C2 = 3'b100,
    D0 = 3'b101,
    D1 = 3'b110,
    E  = 3'b111,
    F  = 3'b001 // reuse B's code? No, must avoid reuse. Let's choose a unique encoding.

    // Since we need unique encodings for all states, let's reassign:

    // Let's assign:
    // A  = 3'b000
    // B  = 3'b001
    // C0 = 3'b010
    // C1 = 3'b011
    // C2 = 3'b100
    // D0 = 3'b101
    // D1 = 3'b110
    // E  = 3'b111
    // F  = 3'b000 (conflict with A) -> we need 4-bit states to avoid conflict

  ) state_t;

  // To avoid conflict, use 4-bit state encoding:

  localparam A  = 4'd0;
  localparam B  = 4'd1;
  localparam C0 = 4'd2;
  localparam C1 = 4'd3;
  localparam C2 = 4'd4;
  localparam D0 = 4'd5;
  localparam D1 = 4'd6;
  localparam E  = 4'd7;
  localparam F  = 4'd8;

  reg [3:0] state, next_state;

  // State register
  always @(posedge clk) begin
    if (~resetn)
      state <= A;
    else
      state <= next_state;
  end

  // Next state logic
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
        // After output f=1 for one cycle, start monitoring x sequence
        // The first x in sequence must be 1
        if (x == 1'b1)
          next_state = C1; // First x=1 detected
        else
          next_state = C0; // Wait for first x=1
      end
      C0: begin
        // Waiting for first x=1 in sequence
        if (x == 1'b1)
          next_state = C1;
        else
          next_state = C0;
      end
      C1: begin
        // We have x=1, next expect x=0
        if (x == 1'b0)
          next_state = C2;
        else if (x == 1'b1)
          next_state = C1; // stay here waiting for 0 after 1
        else
          next_state = C0; // Not 1 or 0? Just reset to C0
      end
      C2: begin
        // We have x=1,0, next expect x=1 to complete sequence
        if (x == 1'b1)
          next_state = D0; // Sequence detected
        else if (x == 1'b0)
          next_state = C0; // sequence broken, start over
        else
          next_state = C0;
      end
      D0: begin
        // g=1 asserted, monitor y first clock cycle
        if (y == 1'b1)
          next_state = E; // y=1 detected, hold g=1
        else
          next_state = D1; // second cycle to check y
      end
      D1: begin
        // second cycle to monitor y
        if (y == 1'b1)
          next_state = E;
        else
          next_state = F;
      end
      E: begin
        // Hold g=1 permanently
        next_state = E;
      end
      F: begin
        // Hold g=0 permanently
        next_state = F;
      end
      default: next_state = A;
    endcase
  end

  // Output logic
  always @(*) begin
    // Defaults
    f = 1'b0;
    g = 1'b0;
    case (state)
      B: f = 1'b1;
      D0, D1, E: g = 1'b1;
      // g=0 in all other states including F, A, B, C0, C1, C2
    endcase
  end

endmodule
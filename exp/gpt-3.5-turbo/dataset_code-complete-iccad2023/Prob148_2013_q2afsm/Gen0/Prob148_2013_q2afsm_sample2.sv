module TopModule (
  input clk,
  input resetn,
  input [3:1] r,
  output [3:1] g
);

  // Define state codes
  localparam A = 2'b00;
  localparam B = 2'b01;
  localparam C = 2'b10;
  localparam D = 2'b11;

  reg [1:0] state, next_state;

  // State flip-flop
  always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
      state <= A;
    end else begin
      state <= next_state;
    end
  end

  // State table logic
  always @* begin
    // Default next state
    next_state = state;

    // State transitions
    case (state)
      A: begin
        if(r[1]) next_state = B;
        else if(r[2]) next_state = C;
        else if(r[3]) next_state = D;
      end
      B: begin
        if(r[1]) next_state = B;
        else next_state = A;
      end
      C: begin
        if(r[2]) next_state = C;
        else next_state = A;
      end
      D: begin
        next_state = D;
      end
    endcase
  end

  // FSM outputs
  assign g[1] = (state == B) ? 1 : 0;
  assign g[2] = (state == C) ? 1 : 0;
  assign g[3] = (state == D) ? 1 : 0;

endmodule
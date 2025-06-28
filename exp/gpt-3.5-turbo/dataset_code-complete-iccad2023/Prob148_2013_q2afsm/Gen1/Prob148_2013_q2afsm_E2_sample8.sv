module TopModule (
  input clk,
  input resetn,
  input [3:1] r,
  output reg [3:1] g
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
        next_state = (r[1]) ? B : (r[2]) ? C : (r[3]) ? D : A;
      end
      B: begin
        next_state = (r[1]) ? B : A;
      end
      C: begin
        next_state = (r[2]) ? C : A;
      end
      D: begin
        next_state = A;
      end
    endcase
  end

  // FSM outputs
  always @* begin
    g = 3'b000; // Default all grant signals to 0
    
    case(state)
      B: g[1] = 1;
      C: g[2] = 1;
      D: g[3] = 1;
    endcase
  end

endmodule
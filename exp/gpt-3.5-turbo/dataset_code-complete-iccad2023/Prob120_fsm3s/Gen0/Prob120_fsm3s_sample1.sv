module MooreStateMachine (
  input clk,
  input in,
  input reset,
  output reg out,
  output reg state_out
);

  // Define states
  parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;
  
  // State register
  reg [1:0] state_reg, next_state;
  
  // Moore state machine
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state_reg <= A;
    end else begin
      state_reg <= next_state;
    end
  end
  
  always @(*) begin
    case(state_reg)
      A: begin
        if (in)
          next_state = B;
        else
          next_state = A;
        out = 0;
      end
      B: begin
        if (in)
          next_state = B;
        else
          next_state = C;
        out = 0;
      end
      C: begin
        if (in)
          next_state = D;
        else
          next_state = A;
        out = 0;
      end
      D: begin
        if (in)
          next_state = B;
        else
          next_state = C;
        out = 1;
      end
      default: begin
        next_state = A;
        out = 0;
      end
    endcase
  end
  
  // Output register
  always @(posedge clk) begin
    state_out <= state_reg;
  end

endmodule

module TopModule (
  input clk,
  input in,
  input reset,
  output out
);

  reg out;
  reg [1:0] state_out;
  
  MooreStateMachine fsm (
    .clk(clk),
    .in(in),
    .reset(reset),
    .out(out),
    .state_out(state_out)
  );

endmodule
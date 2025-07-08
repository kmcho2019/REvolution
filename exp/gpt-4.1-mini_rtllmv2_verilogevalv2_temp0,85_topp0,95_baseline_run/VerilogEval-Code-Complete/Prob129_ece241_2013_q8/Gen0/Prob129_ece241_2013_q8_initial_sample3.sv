module TopModule (
  input clk,
  input aresetn,
  input x,
  output reg z
);

  // state encoding
  typedef enum reg [1:0] {S0=2'b00, S1=2'b01, S2=2'b10} state_t;
  reg [1:0] state, next_state;

  // asynchronous negative edge reset
  always @(negedge aresetn or posedge clk) begin
    if (~aresetn)
      state <= S0;
    else
      state <= next_state;
  end

  // next state logic and output logic
  always @(*) begin
    z = 0;
    case(state)
      S0: begin
        if (x)
          next_state = S1;
        else
          next_state = S0;
      end
      S1: begin
        if (~x)
          next_state = S2;
        else
          next_state = S1;
      end
      S2: begin
        if (x) begin
          next_state = S1;
          z = 1;  // sequence "101" detected on this transition
        end else
          next_state = S0;
      end
      default: begin
        next_state = S0;
        z = 0;
      end
    endcase
  end

endmodule
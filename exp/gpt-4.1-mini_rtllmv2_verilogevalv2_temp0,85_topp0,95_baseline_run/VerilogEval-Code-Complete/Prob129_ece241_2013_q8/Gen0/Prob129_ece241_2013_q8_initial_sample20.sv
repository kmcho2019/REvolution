module TopModule (
  input clk,
  input aresetn,
  input x,
  output reg z
);

  // State encoding
  localparam S0 = 2'b00; // no match
  localparam S1 = 2'b01; // matched '1'
  localparam S2 = 2'b10; // matched '10'

  reg [1:0] state, next_state;

  // State register with negative edge asynchronous reset
  always @(negedge aresetn or posedge clk) begin
    if (!aresetn)
      state <= S0;
    else
      state <= next_state;
  end

  // Next state logic and output logic (Mealy FSM)
  always @(*) begin
    z = 1'b0;
    case (state)
      S0: begin
        if (x)
          next_state = S1;
        else
          next_state = S0;
      end

      S1: begin
        if (x)
          next_state = S1;
        else
          next_state = S2;
      end

      S2: begin
        if (x) begin
          z = 1'b1;      // sequence "101" detected
          next_state = S1; // overlapping detection
        end else
          next_state = S0;
      end

      default: begin
        next_state = S0;
        z = 1'b0;
      end
    endcase
  end

endmodule
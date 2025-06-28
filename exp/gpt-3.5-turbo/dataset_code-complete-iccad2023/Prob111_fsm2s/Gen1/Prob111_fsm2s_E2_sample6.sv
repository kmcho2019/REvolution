module TopModule (
  input clk,
  input j,
  input k,
  input reset,
  output reg out
);

  // State definitions
  parameter OFF = 2'b00;
  parameter ON = 2'b01;

  // State and next state variables
  reg [1:0] state, next_state;

  always@(posedge clk, posedge reset)
  begin
    if (reset)
      state <= OFF;
    else
      state <= next_state;
  end

  always @(*)
  begin
    case (state)
      OFF: begin
        if (j)
          next_state = ON;
        else
          next_state = OFF;
        out = 1'b0;
      end

      ON: begin
        if (k)
          next_state = OFF;
        else
          next_state = ON;
        out = 1'b1;
      end
    endcase
  end
  
endmodule
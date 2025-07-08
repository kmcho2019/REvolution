module TopModule (
  input clk,
  input j,
  input k,
  input reset,
  output out
);

  // Define states
  parameter OFF = 1'b0;
  parameter ON  = 1'b1;
  
  reg state;
  
  always @(posedge clk) begin
    if (reset) begin
      state <= OFF;
    end
    else begin
      case (state)
        OFF: state <= j ? ON : OFF;
        ON:  state <= k ? OFF : ON;
      endcase
    end
  end
  
  // Output depends only on current state (Moore machine)
  assign out = state;

endmodule
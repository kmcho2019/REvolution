module TopModule (
  input clock,
  input a,
  output reg p,
  output reg q
);

  reg current_state;
  reg next_state;

  always @(posedge clock) begin
    current_state <= next_state;
  end

  always @* begin
    next_state = (current_state == 2'b00) ? (a ? 2'b01 : 2'b00) :
                 (current_state == 2'b01) ? (a ? 2'b10 : 2'b00) : 2'b00;
    
    p = (current_state == 2'b01) ? 1 : 0;
    q = (current_state == 2'b10) ? 1 : 0;
  end

endmodule
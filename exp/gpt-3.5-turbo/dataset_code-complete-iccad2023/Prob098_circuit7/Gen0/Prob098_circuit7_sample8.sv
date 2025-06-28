module TopModule (
  input clk,
  input a,
  output reg q
);

// D flip-flop with asynchronous reset
always @(posedge clk or negedge a)
begin
  if (~a)  // Asynchronous reset when 'a' is low
    q <= 0;
  else     // D input updates 'q' on rising edge of clock
    q <= a;
end

endmodule
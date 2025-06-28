module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

reg [2:0] q_next;

always @* begin
  q_next = q;
  
  if (a && ~q_next[2]) begin
    q_next = q + 1;
  end else if (~a) begin
    q_next = 3'b0;
  end
end

always @(posedge clk) begin
  q <= q_next;
end

endmodule
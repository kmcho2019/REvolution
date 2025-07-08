module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output state
);

assign state = q;

wire q_next;

assign q_next = (a & b) ? ~q :
                (~a & b) ? 1'b1 :
                (a & ~b) ? 1'b0 :
                           ~q;

always @(posedge clk) begin
  q <= q_next;
end

endmodule
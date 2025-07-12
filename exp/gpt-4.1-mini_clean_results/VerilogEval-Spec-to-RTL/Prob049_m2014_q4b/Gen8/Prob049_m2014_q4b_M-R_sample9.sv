module TopModule(input clk, input ar, input d, output reg q);

  reg q_next;

  // Combinational logic to determine next state with asynchronous reset
  always @(*) begin
    if (ar)
      q_next = 1'b0;
    else
      q_next = d;
  end

  // Flip-flop with asynchronous reset effect by updating q on clock edge
  always @(posedge clk or posedge ar) begin
    if (ar)
      q <= 1'b0;
    else
      q <= q_next;
  end

endmodule
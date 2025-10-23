module TopModule (
  input  clk,
  input  load,
  input [511:0] data,
  output reg [511:0] q
);

  reg [511:0] q_next;

  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      q <= q_next;
    end
  end

  always @(*) begin
    q_next[0] = (q[0] == 1'b0 && q[1] == 1'b1) || (q[0] == 1'b1 && q[1] == 1'b0);
    q_next[511] = (q[510] == 1'b0 && q[511] == 1'b1) || (q[510] == 1'b1 && q[511] == 1'b0);
    for (genvar i = 1; i < 511; i++) begin
      q_next[i] = (q[i-1] == 1'b0 && q[i+1] == 1'b1) || (q[i-1] == 1'b1 && q[i+1] == 1'b0);
    end
  end

endmodule
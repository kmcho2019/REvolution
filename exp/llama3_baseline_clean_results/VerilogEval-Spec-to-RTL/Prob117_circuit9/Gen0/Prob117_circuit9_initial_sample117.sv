module TopModule(clk, a, q);
  input clk;
  input a;
  output [2:0] q;
  reg [2:0] q;

  always @(posedge clk) begin
    if(a) begin
      q <= q; // hold the current count
    end else begin
      q <= q + 1; // increment the counter
    end
  end

  initial begin
    q = 4'b0100; // initialize q to 4
  end
endmodule
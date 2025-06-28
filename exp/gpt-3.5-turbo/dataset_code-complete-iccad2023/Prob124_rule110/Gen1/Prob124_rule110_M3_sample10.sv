module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);

  // Combinational logic block for Rule 110
  always @(*)
  begin
    integer i;

    // Handle the boundary case for q[512]
    q[511] = (~q[510] & data[511]) | (~q[510] & ~data[511]) | (q[510] & data[511]);

    for (i = 1; i < 511; i = i + 1) begin
      q[i] = (~q[i-1] & q[i] & q[i+1]) | (~q[i-1] & ~q[i] & ~q[i+1]) | (q[i-1] & ~q[i] & q[i+1]);
    end

    // Handle the boundary case for q[-1]
    q[0] = (data[0] & data[1]) | (data[0] & ~data[1]);
  end

  // Synchronous always block for updating cell states
  always @(posedge clk)
  begin
    if (load)
      q <= data;
  end

endmodule
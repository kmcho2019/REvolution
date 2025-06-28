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

    for (i = 0; i < 512; i = i + 1) begin
      if (i == 0) begin
        q[i] = (data[i] & data[i+1]) | (data[i] & ~data[i+1]);
      end else if (i == 511) begin
        q[i] = (data[i-1] & data[i]) | (~data[i-1] & data[i]);
      end else begin
        q[i] = (~data[i-1] & data[i] & data[i+1]) | (~data[i-1] & ~data[i] & ~data[i+1]) | (data[i-1] & ~data[i] & data[i+1]);
      end
    end
  end

  // Synchronous always block for updating cell states
  always @(posedge clk)
  begin
    if (load)
      q <= data;
    else
      q <= q;
  end

endmodule
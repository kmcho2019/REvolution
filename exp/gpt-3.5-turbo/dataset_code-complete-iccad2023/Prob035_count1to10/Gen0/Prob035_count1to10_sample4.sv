module TopModule (
  input clk,
  input reset,
  output reg [3:0] q
);

  always @ (posedge clk or posedge reset)
  begin
    if (reset)
      q <= 4'b0001; // reset to 1 when RESET is high
    else
    begin
      if (q == 4'b1010) // if counter reaches 10, reset to 1
        q <= 4'b0001;
      else
        q <= q + 4'b0001; // increment counter
    end
  end

endmodule
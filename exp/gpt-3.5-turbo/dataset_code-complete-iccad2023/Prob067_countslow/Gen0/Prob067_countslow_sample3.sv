module TopModule (
  input clk,
  input slowena,
  input reset,
  output reg [3:0] q
);

// Internal wire to track when the counter should increment
reg should_increment;

always @ (posedge clk) begin
  if (reset) begin
    q <= 4'b0000;
    should_increment <= 1'b0;
  end else if (slowena) begin
    should_increment <= 1'b1;
  end
  
  if (should_increment) begin
    if (q == 4'b1001) begin
      q <= 4'b0000;
    end else begin
      q <= q + 1;
    end
  end
end

endmodule
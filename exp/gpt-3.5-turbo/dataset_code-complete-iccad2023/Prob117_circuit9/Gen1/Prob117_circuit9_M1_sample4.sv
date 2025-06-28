module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

reg reset_counter;

always @ (posedge clk) begin
  if (a && !reset_counter) begin
    if (q < 3'd6) // Counter should increment from 0 to 6
      q <= q + 1;
  end else begin
    reset_counter <= (a == 1'b0);
    if (reset_counter) begin
      q <= 3'b0; // Reset counter to 0 when 'a' remains low
    end
  end
end

endmodule
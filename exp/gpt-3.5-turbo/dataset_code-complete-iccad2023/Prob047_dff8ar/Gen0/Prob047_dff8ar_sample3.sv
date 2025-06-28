module TopModule (
  input clk,
  input [7:0] d,
  input areset,
  output reg [7:0] q
);

reg [7:0] q_temp; // Temporary storage for output

always @ (posedge clk or posedge areset)
begin
  if (areset)
    q_temp <= 8'b0; // Reset to 0 on active high asynchronous reset
  else
    q_temp <= d; // Update outputs with input values on positive clock edge
end

// Assigning outputs after clock edge for synchronous behavior
always @ (posedge clk)
begin
  q <= q_temp;
end

endmodule
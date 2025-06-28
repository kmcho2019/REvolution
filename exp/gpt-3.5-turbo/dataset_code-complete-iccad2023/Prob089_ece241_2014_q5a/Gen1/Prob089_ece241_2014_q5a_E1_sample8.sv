module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

// Registers
reg [7:0] result;

// Always block to calculate 2's complement
always @(posedge clk or posedge areset) begin
  if (areset) begin
    result <= 0;
    z <= 0;
  end else begin
    // Calculate 2's complement
    if (x) begin
      result <= result - 1;
    end
    z <= result;
  end
end

endmodule
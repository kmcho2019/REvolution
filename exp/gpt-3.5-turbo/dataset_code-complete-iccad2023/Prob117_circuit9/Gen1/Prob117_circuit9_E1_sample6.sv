module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

always @ (posedge clk) begin
  case({a, q})
    2'b10: q <= q + 1; // Increment the counter when a changes from 1 to 0
    2'b00: q <= 3'b100; // Reset the counter to 4 when a remains low
    default: q <= q; // Default state remains unchanged
  endcase
end

endmodule
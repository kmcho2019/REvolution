module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

// Define internal signals
reg [7:0] result;
reg [7:0] twos_complement;

// State machine
always @(posedge clk or posedge areset) begin
    if (areset) begin
        result <= 8'h00;
        twos_complement <= 8'h00;
    end
    else begin
        twos_complement <= {x, ~x} + 1; // Calculate 2's complement of input x
        result <= {result[6:0], twos_complement[7]}; // Shift and accumulate 2's complement result
    end
end

// Output
assign z = result;

endmodule
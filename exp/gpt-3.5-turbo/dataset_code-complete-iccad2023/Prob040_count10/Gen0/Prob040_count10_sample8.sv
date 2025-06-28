module TopModule (
  input clk,
  input reset,
  output reg [3:0] q
);

// State variable representing the current count
reg [3:0] count;

// Always block to handle counting and resetting
always @(posedge clk) begin
  if (reset) begin
    count <= 4'b0000;
  end
  else begin
    if (count == 4'b1001) begin
      count <= 4'b0000;
    end
    else begin
      count <= count + 1;
    end
  end
end

// Output the count value
assign q = count;

endmodule
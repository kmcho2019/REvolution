module TopModule (
  input clk,
  input load,
  input [9:0] data,
  output reg tc
);

reg [9:0] counter;

always @ (posedge clk) begin
  if (load == 1) begin
    counter <= data;
  end else begin
    if (counter > 0) begin
      counter <= counter - 1;
    end
  end
  tc <= (counter == 0);
end

endmodule
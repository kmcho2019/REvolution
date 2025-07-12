module TopModule(
  input clk,
  input load,
  input [9:0] data,
  output reg tc
);

reg [9:0] counter;

always @(posedge clk) begin
  if (load == 1'b1) begin
    counter <= data;
    tc <= 1'b0;
  end else if (counter > 10'd0) begin
    counter <= counter - 1'd1;
    tc <= 1'b0;
  end else begin
    tc <= 1'b1;
  end
end

endmodule
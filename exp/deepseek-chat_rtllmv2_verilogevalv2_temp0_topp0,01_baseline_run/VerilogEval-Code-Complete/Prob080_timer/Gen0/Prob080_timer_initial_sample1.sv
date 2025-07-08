module TopModule (
  input clk,
  input load,
  input [9:0] data,
  output reg tc
);

  reg [9:0] counter;

  always @(posedge clk) begin
    if (load) begin
      counter <= data;
      tc <= (data == 10'b0);  // If loading 0, tc should be 1 immediately
    end else if (counter != 10'b0) begin
      counter <= counter - 1'b1;
      tc <= (counter == 10'b1);  // Next cycle will be 0
    end else begin
      tc <= 1'b1;  // Stay at 0 and keep tc asserted
    end
  end

endmodule
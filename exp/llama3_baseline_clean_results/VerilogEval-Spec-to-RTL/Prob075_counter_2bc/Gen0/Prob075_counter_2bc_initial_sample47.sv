module TopModule (
  input  clk,
  input  areset,
  input  train_valid,
  input  train_taken,
  output [1:0] state
);

reg [1:0] counter;

always @(posedge clk or posedge areset) begin
  if (areset) begin
    counter <= 2'b01;
  end else begin
    case ({train_valid, train_taken})
      2'b11: counter <= (counter == 2'b11) ? counter : counter + 1'b1;
      2'b10: counter <= (counter == 2'b00) ? counter : counter - 1'b1;
      default: counter <= counter;
    endcase
  end
end

assign state = counter;

endmodule
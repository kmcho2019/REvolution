module TopModule (
  input clk,
  input reset,
  output reg shift_ena
);

  reg [1:0] count;

  always @(posedge clk) begin
    if (reset) begin
      count <= 2'b00;
      shift_ena <= 1'b1;
    end else if (shift_ena) begin
      if (count == 2'd3) begin
        shift_ena <= 1'b0;
      end else begin
        count <= count + 1;
      end
    end
  end

endmodule
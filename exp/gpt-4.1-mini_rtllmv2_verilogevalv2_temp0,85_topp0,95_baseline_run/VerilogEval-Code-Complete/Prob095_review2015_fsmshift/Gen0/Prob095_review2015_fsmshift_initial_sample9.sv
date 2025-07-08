module TopModule (
  input clk,
  input reset,
  output shift_ena
);

  reg [1:0] cnt;
  reg shift_ena_reg;

  assign shift_ena = shift_ena_reg;

  always @(posedge clk) begin
    if (reset) begin
      cnt <= 2'd3;        // 4 cycles counting down: 3,2,1,0
      shift_ena_reg <= 1'b1;
    end else if (cnt != 2'd0) begin
      cnt <= cnt - 1;
      shift_ena_reg <= 1'b1;
    end else begin
      shift_ena_reg <= 1'b0;
    end
  end

endmodule
module TopModule (
  input clk,
  input reset,
  output shift_ena
);

  reg [1:0] cnt;
  reg shift_ena_reg;

  always @(posedge clk) begin
    if (reset) begin
      cnt <= 2'b00;
      shift_ena_reg <= 1'b1;
    end else if (shift_ena_reg) begin
      cnt <= cnt + 1;
      if (cnt == 2'd3) // after 4 clock cycles (0,1,2,3)
        shift_ena_reg <= 1'b0;
    end
  end

  assign shift_ena = shift_ena_reg;

endmodule
module TopModule (
  input clk,
  input reset,
  output shift_ena
);

  reg [2:0] cnt;
  reg shift_ena_reg;

  always @(posedge clk) begin
    if (reset) begin
      cnt <= 3'b000;
      shift_ena_reg <= 1'b1;
    end else if (shift_ena_reg) begin
      if (cnt == 3'd3) begin
        shift_ena_reg <= 1'b0;
        cnt <= cnt;
      end else begin
        cnt <= cnt + 1'b1;
      end
    end
  end

  assign shift_ena = shift_ena_reg;

endmodule
module TopModule (
  input clk,
  input reset,
  output shift_ena
);

  reg [2:0] count;
  reg shift_ena_reg;

  always @(posedge clk) begin
    if (reset) begin
      count <= 3'd4;       // Load count with 4 at reset
      shift_ena_reg <= 1'b1;
    end else if (count != 3'd0) begin
      count <= count - 3'd1;
      if (count == 3'd1)
        shift_ena_reg <= 1'b0;
    end else begin
      shift_ena_reg <= 1'b0;
    end
  end

  assign shift_ena = shift_ena_reg;

endmodule
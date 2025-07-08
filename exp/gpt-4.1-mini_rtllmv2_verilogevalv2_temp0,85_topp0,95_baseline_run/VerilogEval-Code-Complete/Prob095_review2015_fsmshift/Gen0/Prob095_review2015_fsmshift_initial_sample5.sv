module TopModule (
  input clk,
  input reset,
  output shift_ena
);

  reg [2:0] cnt; // 3-bit counter sufficient for count to 4
  reg shift_ena_r;

  always @(posedge clk) begin
    if (reset) begin
      cnt <= 3'd4;
    end else if (cnt != 3'd0) begin
      cnt <= cnt - 1;
    end
  end

  always @(posedge clk) begin
    if (reset) begin
      shift_ena_r <= 1'b1;
    end else if (cnt != 3'd0) begin
      shift_ena_r <= 1'b1;
    end else begin
      shift_ena_r <= 1'b0;
    end
  end

  assign shift_ena = shift_ena_r;

endmodule
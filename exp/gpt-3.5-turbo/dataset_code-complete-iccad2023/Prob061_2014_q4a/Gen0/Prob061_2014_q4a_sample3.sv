module TopModule (
  input clk,
  input w,
  input R,
  input E,
  input L,
  output reg Q
);

  reg [1:0] reg_value;
  reg Q_next;

  always @ (posedge clk) begin
    if (L) begin
      reg_value <= R;
    end
    else if (E) begin
      reg_value <= {reg_value[0], w};
    end
  end

  // Multiplexers to select between loading and shifting
  always @ (*) begin
    if (L) begin
      Q_next = R;
    end
    else if (E) begin
      Q_next = reg_value[1];
    end
  end

  always @ (posedge clk) begin
    Q <= Q_next;
  end

endmodule
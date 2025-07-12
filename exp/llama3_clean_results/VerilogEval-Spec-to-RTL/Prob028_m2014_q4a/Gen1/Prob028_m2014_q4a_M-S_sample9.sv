module TopModule(d, ena, q);
  input d;
  input ena;
  output reg q;

  always @(ena or d) begin
    if (ena) begin
      q = d;
    end else begin
      // Do nothing to 'q', implying it retains its value
    end
  end
endmodule
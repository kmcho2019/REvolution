module TopModule(d, ena, q);
  input d;
  input ena;
  output reg q;

  always @(posedge ena or negedge ena) begin
    if (ena) begin
      q <= d;
    end
  end
endmodule
module DFF (
  input clk,
  input d,
  input ar,
  output reg q
);

always @(posedge clk or posedge ar) begin
  if (ar) begin
    q <= 1'b0;
  end else begin
    q <= d;
  end
end

endmodule

module TopModule (
  input clk,
  input d,
  input ar,
  output logic q
);

DFF dff_inst (
  .clk(clk),
  .d(d),
  .ar(ar),
  .q(q)
);

endmodule
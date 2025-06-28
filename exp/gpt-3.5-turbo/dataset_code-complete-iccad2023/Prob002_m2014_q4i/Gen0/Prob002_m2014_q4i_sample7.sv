module TopModule (
  output out
);

  // Assign the output 'out' to logic low
  always @(*) begin
    out = 0;
  end

endmodule
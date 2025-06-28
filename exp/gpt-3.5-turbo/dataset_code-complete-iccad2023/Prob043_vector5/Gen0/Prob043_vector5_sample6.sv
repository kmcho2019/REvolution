module TopModule (
  input a,
  input b,
  input c,
  input d,
  input e,
  output [24:0] out
);

genvar i;
generate
  for (i = 0; i < 25; i = i + 1) begin
    assign out[i] = ~a ^ (i[4] ? e : (i[3] ? d : (i[2] ? c : (i[1] ? b : a))));
  end
endgenerate

endmodule
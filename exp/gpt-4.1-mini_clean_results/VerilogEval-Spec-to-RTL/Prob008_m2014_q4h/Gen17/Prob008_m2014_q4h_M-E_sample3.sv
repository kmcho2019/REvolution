module TopModule (
    input  in,
    output out
);
  wire one = 1'b1;
  assign out = in & one;
endmodule
module TopModule(output reg out);
  // Since there is no input, use initial block to drive out to 0 constantly.
  initial begin
    out = 0;
  end
endmodule
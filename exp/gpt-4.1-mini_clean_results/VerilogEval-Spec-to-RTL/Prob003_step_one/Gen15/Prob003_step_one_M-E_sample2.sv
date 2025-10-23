module TopModule(output one);
  // Define a parameter holding constant logic high
  parameter logic_one = 1'b1;
  // Continuous assignment from parameter to output
  assign one = logic_one;
endmodule
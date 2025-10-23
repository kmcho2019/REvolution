module TopModule(output wire one);
  // Define a parameter for the constant high value
  localparam logic HIGH = 1'b1;
  // Drive output 'one' with the constant high parameter
  assign one = HIGH;
endmodule
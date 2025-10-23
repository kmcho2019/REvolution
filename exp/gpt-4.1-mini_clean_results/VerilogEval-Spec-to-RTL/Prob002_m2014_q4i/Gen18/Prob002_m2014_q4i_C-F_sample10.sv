module TopModule(output out);
  // Define a localparam for constant zero to improve clarity and maintainability
  localparam logic ZERO_CONST = 1'b0;
  assign out = ZERO_CONST;
endmodule
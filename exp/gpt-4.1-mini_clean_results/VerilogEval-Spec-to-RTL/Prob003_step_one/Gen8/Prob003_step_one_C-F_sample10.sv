module TopModule(output one);
    // Internal parameter defines the constant output value
    localparam ONE_VALUE = 1'b1;
    // Drive the output directly from the parameter constant
    assign one = ONE_VALUE;
endmodule
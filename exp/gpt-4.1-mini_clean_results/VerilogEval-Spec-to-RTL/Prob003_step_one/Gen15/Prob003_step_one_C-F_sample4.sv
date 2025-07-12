module TopModule(output one);
    // Local parameter for the constant output value, easily changeable if needed
    localparam ONE_VAL = 1'b1;

    // Direct continuous assignment to the parameter value, ensures minimal area/power
    assign one = ONE_VAL;
endmodule
module ParamConst #(parameter VALUE = 1'b0) (output wire out);
    assign out = VALUE;
endmodule

module TopModule(output wire one);
    // Instantiate ParamConst with VALUE=1 to drive output high
    ParamConst #(1'b1) const_inst (.out(one));
endmodule
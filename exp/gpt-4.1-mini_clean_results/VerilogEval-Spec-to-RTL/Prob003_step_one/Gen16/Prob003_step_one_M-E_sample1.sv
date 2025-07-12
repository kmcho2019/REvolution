module ConstantDriver #(parameter VALUE = 1'b1) (output wire out);
    assign out = VALUE;
endmodule

module TopModule(output wire one);
    ConstantDriver #(.VALUE(1'b1)) const_inst (.out(one));
endmodule
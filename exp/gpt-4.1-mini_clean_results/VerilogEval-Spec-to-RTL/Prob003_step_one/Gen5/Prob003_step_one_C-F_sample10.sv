module ConstValue #(parameter VALUE = 1'b1) (output wire out);
    // Output is tied to the parameter VALUE
    assign out = VALUE;
endmodule

module TopModule(output wire one);
    // Instantiate the constant logic high module with VALUE=1
    ConstValue #(1'b1) const_inst (.out(one));
endmodule
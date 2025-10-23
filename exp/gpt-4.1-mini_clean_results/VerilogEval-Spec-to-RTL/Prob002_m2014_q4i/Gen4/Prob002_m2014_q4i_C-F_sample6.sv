module ConstantValue #(parameter VALUE = 1'b0) (output out);
    assign out = VALUE;
endmodule

module TopModule(output out);
    ConstantValue #(.VALUE(1'b0)) const_zero_inst (.out(out));
endmodule
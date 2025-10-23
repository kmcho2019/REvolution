module ConstOne(output wire out);
    // Output is tied to logic high
    assign out = 1'b1;
endmodule

module TopModule(output wire one);
    // Instantiate the constant logic high module
    ConstOne const_inst (.out(one));
endmodule
module ConstantDriver(
    parameter OUT_VALUE = 1'b0,
    output out
);
    
    assign out = OUT_VALUE;
    
endmodule

module TopModule(
    output out
);
    
    ConstantDriver #(.OUT_VALUE(1'b0)) constant_driver(out);
    
endmodule
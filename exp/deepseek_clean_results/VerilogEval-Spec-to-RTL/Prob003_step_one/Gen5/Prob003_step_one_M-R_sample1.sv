// Refactored version showing alternative styles
module ConstantOneDriver (
    output logic one = 1'b1
);
endmodule

module TopModule (
    output one
);
    // Style 1: Direct wire assignment
    wire one_wire = 1'b1;
    
    // Style 2: Using a submodule
    ConstantOneDriver driver(.one(one_sub));
    
    // Style 3: Parameterized selection (though only one option here)
    localparam OUTPUT_VALUE = 1;
    assign one = OUTPUT_VALUE;
    
    // Any of these would work, we'll use the simplest:
    assign one = one_wire;
endmodule
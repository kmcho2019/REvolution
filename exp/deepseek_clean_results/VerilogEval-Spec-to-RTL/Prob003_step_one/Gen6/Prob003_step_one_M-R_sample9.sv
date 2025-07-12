// Option 1: Continuous assignment with explicit width
module TopModule(output one);
    assign one = 1'b1;
endmodule

// Option 2: Wire with direct assignment
/*
module TopModule(output one);
    wire one = 1'b1;
endmodule
*/

// Option 3: Parameter with explicit width
/*
module TopModule(output one);
    parameter [0:0] ONE = 1'b1;
    assign one = ONE;
endmodule
*/
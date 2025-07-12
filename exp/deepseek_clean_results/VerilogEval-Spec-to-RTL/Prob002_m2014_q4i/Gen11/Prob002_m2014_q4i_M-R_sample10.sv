// Alternative 1: Using wire declaration with constant assignment
module TopModule (
    output out
);
    wire out = 1'b0;
endmodule

// Alternative 2: Using a parameter (though not necessary for this simple case)
module TopModule #(
    parameter VALUE = 1'b0
) (
    output out
);
    assign out = VALUE;
endmodule
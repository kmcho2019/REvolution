// Alternative 1: Parameterized module
module TopModule #(
    parameter WIDTH = 1
) (
    input in,
    output out
);
    assign out = ~in;
endmodule

// Alternative 2: Always block implementation
/*
module TopModule (
    input in,
    output reg out
);
    always @(*) begin
        out = ~in;
    end
endmodule
*/
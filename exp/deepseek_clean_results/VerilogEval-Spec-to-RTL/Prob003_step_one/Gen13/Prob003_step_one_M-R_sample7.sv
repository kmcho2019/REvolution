// Alternative 1: Using always block (behavioral style)
module TopModule (
    output reg one
);
    always @(*) begin
        one = 1'b1;
    end
endmodule

// Alternative 2: Using parameter (declarative style)
module TopModule (
    output one
);
    parameter CONST_ONE = 1'b1;
    assign one = CONST_ONE;
endmodule
module TopModule (
    input a,
    input b,
    input sel,
    output reg out
);
    // 2:1 multiplexer implemented with procedural block
    // Same functionality as ternary version but using if-else
    always @* begin
        if (sel == 1'b0)
            out = a;
        else
            out = b;
    end
endmodule
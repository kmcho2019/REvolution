// Alternative 1: Behavioral style with always block
module TopModule (
    input in,
    output reg out
);
    always @(*) begin
        out = ~in;
    end
endmodule

// Alternative 2: Structural style using Verilog primitive
/*
module TopModule (
    input in,
    output out
);
    not inv1(out, in);
endmodule
*/
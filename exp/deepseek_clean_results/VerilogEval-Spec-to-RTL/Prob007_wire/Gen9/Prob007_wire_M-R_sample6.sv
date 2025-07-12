// Alternative 1: Behavioral style with always block
module TopModule (
    input in,
    output reg out
);
    always @(*) begin
        out = in;
    end
endmodule

// Alternative 2: Structural style with module instantiation
/*
module WireCell (
    input a,
    output b
);
    assign b = a;
endmodule

module TopModule (
    input in,
    output out
);
    WireCell u_wire (.a(in), .b(out));
endmodule
*/
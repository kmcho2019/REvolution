module TopModule (
    output out
);
    wire x = 1'b1;      // Constant 1
    assign out = x & ~x; // Always 0 by boolean identity
endmodule
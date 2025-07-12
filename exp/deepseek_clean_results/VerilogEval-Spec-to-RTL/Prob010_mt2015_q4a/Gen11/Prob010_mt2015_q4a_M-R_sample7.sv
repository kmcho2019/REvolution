// Alternative 1: Using explicit XOR and AND operations
module TopModule (
    input x,
    input y,
    output z
);
    assign z = (x ^ y) & x;
endmodule

// Alternative 2: Using always block
module TopModule (
    input x,
    input y,
    output reg z
);
    always @(*) begin
        z = (x ^ y) & x;
    end
endmodule

// Alternative 3: Using gate-level primitives
module TopModule (
    input x,
    input y,
    output z
);
    wire xor_out;
    xor(xor_out, x, y);
    and(z, xor_out, x);
endmodule
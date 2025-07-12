// Module A: z = (x XOR y) AND x
module A (
    input  wire x,
    input  wire y,
    output reg  z
);
    always @(*) begin
        z = (x ^ y) & x;
    end
endmodule

// Module B: z = XNOR of x and y (z = ~(x ^ y))
module B (
    input  wire x,
    input  wire y,
    output reg  z
);
    always @(*) begin
        z = ~(x ^ y);
    end
endmodule

// Top-level module implementing:
// z = XOR( OR( A_out, B_out ), AND( A_out, B_out ) )
// Where A_out = A(x,y), B_out = B(x,y)
module TopModule (
    input  wire x,
    input  wire y,
    output reg  z
);
    wire a_out;
    wire b_out;
    reg or_out;
    reg and_out;

    // Single instances of A and B modules
    A a_inst (
        .x(x),
        .y(y),
        .z(a_out)
    );

    B b_inst (
        .x(x),
        .y(y),
        .z(b_out)
    );

    always @(*) begin
        or_out  = a_out | b_out;
        and_out = a_out & b_out;
        z       = or_out ^ and_out;
    end
endmodule
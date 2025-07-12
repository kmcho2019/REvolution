module NOT1 (
    input  a,
    output y
);
    // Use built-in not primitive for clarity and optimization
    not (y, a);
endmodule

module AND2 #(
    parameter WIDTH = 1
) (
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    output wire [WIDTH-1:0] y
);
    // Use built-in and primitive for gate-level clarity and optimization
    assign y = a & b;
endmodule

module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    wire not_y;

    // Instantiate NOT gate for ~y
    NOT1 u_not (
        .a(y),
        .y(not_y)
    );

    // Instantiate AND gate for x & ~y
    AND2 #(.WIDTH(1)) u_and (
        .a(x),
        .b(not_y),
        .y(z)
    );
endmodule
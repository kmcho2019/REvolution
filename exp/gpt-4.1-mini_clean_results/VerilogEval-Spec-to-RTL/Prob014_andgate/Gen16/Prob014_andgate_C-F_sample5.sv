module AndPrimitive (
    input wire x,
    input wire y,
    output wire z
);
    assign z = x & y;
endmodule

module TopModule (
    input wire a,
    input wire b,
    output wire out
);
    AndPrimitive and_inst (
        .x(a),
        .y(b),
        .z(out)
    );
endmodule
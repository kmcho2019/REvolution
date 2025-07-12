module A (
    input  wire x,
    input  wire y,
    output wire z
);
    // z = (x XOR y) AND x
    assign z = (x ^ y) & x;
endmodule

module B (
    input  wire x,
    input  wire y,
    output wire z
);
    // z = XNOR of x and y
    assign z = ~(x ^ y);
endmodule

module TopModule (
    input  wire x,
    input  wire y,
    output reg  z
);
    wire a_out, b_out;
    wire or_out, and_out;

    // Instantiate single instances of A and B
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

    // Use combinational always block for OR and AND outputs
    reg or_reg, and_reg;
    always @(*) begin
        or_reg  = a_out | b_out;
        and_reg = a_out & b_out;
    end

    // Final output z is XOR of OR and AND outputs
    always @(*) begin
        z = or_reg ^ and_reg;
    end
endmodule
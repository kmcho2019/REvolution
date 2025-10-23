// Novel approach using a unified operation module
module UnifiedOperation(
    input  [2:0] a,
    input  [2:0] b,
    input  [1:0] op, // 0: bitwise-OR, 1: logical-OR, 2: inversion of a, 3: inversion of b
    output [2:0] out
);
    always @(*) begin
        case(op)
            2'b00: out = a | b; // Bitwise-OR
            2'b01: out = (a != 3'b000) || (b != 3'b000) ? 3'b001 : 3'b000; // Logical-OR, assuming output should be 3 bits
            2'b10: out = ~a; // Inversion of a
            2'b11: out = ~b; // Inversion of b
            default: out = 3'b000;
        endcase
    end
endmodule

// Top-level module using the unified operation approach
module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output       out_or_logical,
    output [5:0] out_not
);
    wire [2:0] inv_a, inv_b;

    // Instantiate UnifiedOperation for bitwise-OR
    UnifiedOperation u_bitwise_or(
        .a(a),
        .b(b),
        .op(2'b00),
        .out(out_or_bitwise)
    );

    // Instantiate UnifiedOperation for logical-OR, with a slight adjustment for output
    assign out_or_logical = (a != 3'b000) || (b != 3'b000);

    // Instantiate UnifiedOperation for inversion of a and b
    UnifiedOperation u_inv_a(
        .a(a),
        .b(3'b000), // Unused
        .op(2'b10),
        .out(inv_a)
    );

    UnifiedOperation u_inv_b(
        .a(b),
        .b(3'b000), // Unused
        .op(2'b10),
        .out(inv_b)
    );

    // Assign inverted values to out_not
    assign out_not[5:3] = inv_b;
    assign out_not[2:0] = inv_a;
endmodule
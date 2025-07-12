module bit_full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    // Gate-level full adder implementation for optimal synthesis
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

module adder_8bit #(
    parameter WIDTH = 8
)(
    input  wire [WIDTH-1:0] a,   // Operand A
    input  wire [WIDTH-1:0] b,   // Operand B
    input  wire             cin, // Carry-in
    output wire [WIDTH-1:0] sum, // Sum output
    output wire             cout // Carry-out
);
    // Internal carry wires: carry[0] = cin, carry[WIDTH] = cout
    wire [WIDTH:0] carry;
    assign carry[0] = cin;

    genvar i;
    generate
        // Instantiate full adders for each bit
        for (i = 0; i < WIDTH; i = i + 1) begin : gen_fa
            bit_full_adder fa_inst (
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i]),
                .sum(sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

    // Assign final carry-out
    assign cout = carry[WIDTH];

endmodule
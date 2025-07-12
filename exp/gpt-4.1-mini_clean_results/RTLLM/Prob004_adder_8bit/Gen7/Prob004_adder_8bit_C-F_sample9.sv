// Bit-level full adder with explicit propagate and generate signals
module bit_full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    wire p, g;
    assign p    = a ^ b;            // propagate
    assign g    = a & b;            // generate
    assign sum  = p ^ cin;          // sum bit
    assign cout = g | (p & cin);    // carry out
endmodule

// Parameterized 8-bit ripple carry adder using bit_full_adder modules
module adder_8bit #(
    parameter WIDTH = 8
)(
    input  wire [WIDTH-1:0] a,    // Operand A
    input  wire [WIDTH-1:0] b,    // Operand B
    input  wire             cin,  // Carry-in
    output wire [WIDTH-1:0] sum,  // Sum output
    output wire             cout  // Carry-out
);
    wire [WIDTH:0] carry;          // Internal carry signals: carry[0] = cin, carry[WIDTH] = cout

    assign carry[0] = cin;         // Initialize carry-in

    genvar i;
    generate
        // Instantiate full adders for each bit
        for (i = 0; i < WIDTH; i = i + 1) begin : bit_adders
            bit_full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i]),
                .sum(sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

    assign cout = carry[WIDTH];    // Final carry-out
endmodule
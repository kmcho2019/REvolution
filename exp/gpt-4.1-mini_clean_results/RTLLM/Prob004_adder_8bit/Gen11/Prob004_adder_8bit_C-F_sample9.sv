// Single-bit full adder module using minimal gate-level logic
module bit_full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

// 8-bit ripple carry adder composed of 8 bit_full_adders with 7 internal carry wires
module adder_8bit (
    input  wire [7:0] a,    // Operand A
    input  wire [7:0] b,    // Operand B
    input  wire       cin,  // Carry-in
    output wire [7:0] sum,  // Sum output
    output wire       cout  // Carry-out
);

    // Internal carry signals: 7 wires between bits
    wire [6:0] carry;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : full_adder_chain
            if (i == 0) begin
                bit_full_adder fa (
                    .a(a[i]),
                    .b(b[i]),
                    .cin(cin),
                    .sum(sum[i]),
                    .cout(carry[i])
                );
            end else if (i < 7) begin
                bit_full_adder fa (
                    .a(a[i]),
                    .b(b[i]),
                    .cin(carry[i-1]),
                    .sum(sum[i]),
                    .cout(carry[i])
                );
            end else begin // i == 7
                bit_full_adder fa (
                    .a(a[i]),
                    .b(b[i]),
                    .cin(carry[i-1]),
                    .sum(sum[i]),
                    .cout(cout)
                );
            end
        end
    endgenerate

endmodule
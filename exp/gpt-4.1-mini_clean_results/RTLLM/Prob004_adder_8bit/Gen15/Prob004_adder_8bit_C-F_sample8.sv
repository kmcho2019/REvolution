// Single-bit full adder with minimal and balanced combinational logic
module bit_full_adder (
    input  wire a,      // single-bit input a
    input  wire b,      // single-bit input b
    input  wire cin,    // carry-in input
    output wire sum,    // sum output
    output wire cout    // carry-out output
);
    wire axb;
    assign axb  = a ^ b;
    assign sum  = axb ^ cin;
    assign cout = (a & b) | (axb & cin);
endmodule

// 8-bit ripple carry adder using generate loop with explicit carry wires
module adder_8bit (
    input  wire [7:0] a,      // 8-bit input operand A
    input  wire [7:0] b,      // 8-bit input operand B
    input  wire       cin,    // carry-in input
    output wire [7:0] sum,    // 8-bit sum output
    output wire       cout    // carry-out output
);
    // Explicit intermediate carry wires for clarity and debugging
    wire c1, c2, c3, c4, c5, c6, c7;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : full_adder_block
            if (i == 0) begin
                bit_full_adder fa (
                    .a(a[i]),
                    .b(b[i]),
                    .cin(cin),
                    .sum(sum[i]),
                    .cout(c1)
                );
            end else if (i == 7) begin
                bit_full_adder fa (
                    .a(a[i]),
                    .b(b[i]),
                    .cin(
                        // Carry input for MSB is c7
                        c7
                    ),
                    .sum(sum[i]),
                    .cout(cout)
                );
            end else begin
                bit_full_adder fa (
                    .a(a[i]),
                    .b(b[i]),
                    .cin(
                        // Carry inputs for bits 1 to 6 are c(i)
                        (i == 1) ? c1 :
                        (i == 2) ? c2 :
                        (i == 3) ? c3 :
                        (i == 4) ? c4 :
                        (i == 5) ? c5 :
                        c6 // for i == 6
                    ),
                    .sum(sum[i]),
                    .cout(
                        // Carry outputs for bits 1 to 6 connect to next carry wire
                        (i == 1) ? c2 :
                        (i == 2) ? c3 :
                        (i == 3) ? c4 :
                        (i == 4) ? c5 :
                        (i == 5) ? c6 :
                        c7 // for i == 6
                    )
                );
            end
        end
    endgenerate

endmodule
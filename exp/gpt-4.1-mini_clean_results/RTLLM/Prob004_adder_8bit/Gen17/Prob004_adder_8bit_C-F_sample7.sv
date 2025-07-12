// Single-bit full adder with minimal and balanced combinational logic
module bit_full_adder (
    input  wire a,       // single-bit input A
    input  wire b,       // single-bit input B
    input  wire cin,     // carry-in input
    output wire sum,     // sum output
    output wire cout     // carry-out output
);
    wire axb;
    assign axb  = a ^ b;
    assign sum  = axb ^ cin;
    assign cout = (a & b) | (axb & cin);
endmodule

// 8-bit ripple carry adder using generate loop and carry vector for modularity and clarity
module adder_8bit (
    input  wire [7:0] a,     // 8-bit input operand A
    input  wire [7:0] b,     // 8-bit input operand B
    input  wire       cin,   // carry-in input
    output wire [7:0] sum,   // 8-bit sum output
    output wire       cout   // carry-out output
);
    wire [7:0] carry;        // internal carry chain signals

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : full_adder_bits
            if (i == 0) begin
                bit_full_adder fa_inst (
                    .a(a[i]),
                    .b(b[i]),
                    .cin(cin),
                    .sum(sum[i]),
                    .cout(carry[i])
                );
            end else begin
                bit_full_adder fa_inst (
                    .a(a[i]),
                    .b(b[i]),
                    .cin(carry[i-1]),
                    .sum(sum[i]),
                    .cout(carry[i])
                );
            end
        end
    endgenerate

    assign cout = carry[7];

endmodule
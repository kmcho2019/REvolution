// Single-bit full adder with minimal and balanced combinational logic
module bit_full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    wire axb;
    assign axb  = a ^ b;
    assign sum  = axb ^ cin;
    assign cout = (a & b) | (axb & cin);
endmodule

// 8-bit ripple carry adder using generate loop for modular and concise instantiation
module adder_8bit (
    input  wire [7:0] a,    // 8-bit operand A
    input  wire [7:0] b,    // 8-bit operand B
    input  wire       cin,  // carry-in input
    output wire [7:0] sum,  // 8-bit sum output
    output wire       cout  // carry-out output
);
    wire [7:0] carry; // internal carry chain

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : bit_adder
            if (i == 0) begin
                bit_full_adder fa (
                    .a(a[i]),
                    .b(b[i]),
                    .cin(cin),
                    .sum(sum[i]),
                    .cout(carry[i])
                );
            end else begin
                bit_full_adder fa (
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
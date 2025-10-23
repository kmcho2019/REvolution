// 1-bit full adder module
module full_adder_1bit (
    input  wire a,    // 1-bit input A
    input  wire b,    // 1-bit input B
    input  wire cin,  // Carry-in
    output wire sum,  // Sum output
    output wire cout  // Carry-out
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// 8-bit adder using generate-for for ripple carry chain of full adders
module adder_8bit (
    input  wire [7:0] a,    // 8-bit input operand A
    input  wire [7:0] b,    // 8-bit input operand B
    input  wire       cin,  // Carry-in input
    output wire [7:0] sum,  // 8-bit sum output
    output wire       cout  // Carry-out output
);
    wire [7:0] carry;  // Internal carry wires

    genvar i;

    generate
        for (i = 0; i < 8; i = i + 1) begin : full_adders
            if (i == 0) begin
                full_adder_1bit fa (
                    .a(a[i]),
                    .b(b[i]),
                    .cin(cin),
                    .sum(sum[i]),
                    .cout(carry[i])
                );
            end else begin
                full_adder_1bit fa (
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
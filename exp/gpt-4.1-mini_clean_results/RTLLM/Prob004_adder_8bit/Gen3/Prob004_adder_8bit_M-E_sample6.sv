// Half Adder module: sum and carry for two single bits without carry-in
module half_adder (
    input  wire a,
    input  wire b,
    output wire sum,
    output wire cout
);
    assign sum  = a ^ b;  // XOR for sum
    assign cout = a & b;  // AND for carry
endmodule

// Full Adder module: implemented using two half adders and an OR gate for carry-out
module full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    wire ha1_sum, ha1_cout;
    wire ha2_cout;

    // First half adder: add a and b
    half_adder ha1 (
        .a(a),
        .b(b),
        .sum(ha1_sum),
        .cout(ha1_cout)
    );

    // Second half adder: add sum of first HA and carry-in
    half_adder ha2 (
        .a(ha1_sum),
        .b(cin),
        .sum(sum),
        .cout(ha2_cout)
    );

    // Carry-out is OR of carries from both half adders
    assign cout = ha1_cout | ha2_cout;
endmodule

// 8-bit adder using 1 half adder for LSB and 7 full adders for bits 1 to 7
module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire [7:1] carry; // internal carry signals between adders

    // LSB addition using half adder with carry-in as a direct input xor (XOR of carry-in and half adder sum)
    // Since half adder has no carry-in, manually incorporate cin with the first sum
    wire lsb_sum_ha, lsb_cout_ha;
    half_adder ha_lsb (
        .a(a[0]),
        .b(b[0]),
        .sum(lsb_sum_ha),
        .cout(lsb_cout_ha)
    );

    // Adjust sum[0] and carry[1] considering external cin
    assign sum[0] = lsb_sum_ha ^ cin;                 // sum bit 0 with carry-in
    wire carry_from_lsb = (lsb_sum_ha & cin) | lsb_cout_ha; // carry generated after adding cin
    assign carry[1] = carry_from_lsb;

    // Full adders for bits 1 through 7
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : full_adder_block
            full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i]),
                .sum(sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

    // Final carry-out is the carry after the MSB full adder (carry[8])
    // Since carry[8] is not declared, declare a wire for it
    wire carry_out_internal;
    assign carry_out_internal = carry[8];

    // To fix the above, declare carry as [8:1] to hold carry bits 1 to 8
    // So we need to update wire declaration and generate loop

endmodule

// Correction to carry signals to include bit 8
module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire [8:1] carry; // internal carry signals from bit 1 to bit 8

    // LSB half adder
    wire lsb_sum_ha, lsb_cout_ha;
    half_adder ha_lsb (
        .a(a[0]),
        .b(b[0]),
        .sum(lsb_sum_ha),
        .cout(lsb_cout_ha)
    );

    assign sum[0] = lsb_sum_ha ^ cin;                      // sum0 including cin
    assign carry[1] = (lsb_sum_ha & cin) | lsb_cout_ha;   // carry to next bit

    // Full adders for bits 1 to 7
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : fa_block
            full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i]),
                .sum(sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

    // The carry out from the MSB adder (bit 7) is carry[8]
    assign cout = carry[8];
endmodule
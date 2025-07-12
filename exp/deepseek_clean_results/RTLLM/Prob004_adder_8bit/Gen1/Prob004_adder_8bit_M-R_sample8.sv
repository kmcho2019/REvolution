module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    wire [8:0] carry; // 9-bit vector to include cin and cout

    assign carry[0] = cin; // First carry-in comes from input

    // Generate 8 full adders
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : adder_chain
            full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i]),
                .sum(sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

    assign cout = carry[8]; // Final carry becomes output

endmodule

// Full adder module remains the same but is more compact
module full_adder (
    input a, b, cin,
    output sum, cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule
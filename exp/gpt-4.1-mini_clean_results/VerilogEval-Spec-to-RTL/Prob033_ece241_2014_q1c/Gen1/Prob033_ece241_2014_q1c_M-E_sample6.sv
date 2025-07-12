module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output overflow
);
    wire [8:0] carry;  // carry[0] is initial carry-in (0), carry[8] is final carry-out
    assign carry[0] = 1'b0;

    // Generate sum and carry for each bit
    genvar i;
    wire [7:0] sum_bits;
    generate
        for (i = 0; i < 8; i = i + 1) begin : adder_bits
            // sum bit calculation
            assign sum_bits[i] = a[i] ^ b[i] ^ carry[i];
            // carry out calculation
            assign carry[i+1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
        end
    endgenerate

    assign s = sum_bits;
    // Overflow if carry into MSB differs from carry out of MSB
    assign overflow = carry[7] ^ carry[8];

endmodule
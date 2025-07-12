module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output overflow
);
    wire [8:0] sum_ext;    // 9-bit sum to capture carry out
    wire carry_in_msb, carry_out_msb;

    // Perform addition using built-in operator; carry_out at bit 8
    assign sum_ext = {1'b0, a} + {1'b0, b};

    assign s = sum_ext[7:0];

    // Carry into MSB is the carry out from bit 6 addition:
    // Compute carry chain explicitly for bits 0 to 7.
    // Here we compute carry_in and carry_out for MSB bit 7.

    wire [7:0] carry;
    assign carry[0] = 1'b0;  // initial carry in

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : carry_gen
            assign carry[i+1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
        end
    endgenerate

    assign carry_in_msb  = carry[7];  // carry into MSB bit 7
    assign carry_out_msb = carry[8];  // carry out of MSB bit 7

    // Overflow occurs if carry into MSB differs from carry out of MSB
    assign overflow = carry_in_msb ^ carry_out_msb;

endmodule
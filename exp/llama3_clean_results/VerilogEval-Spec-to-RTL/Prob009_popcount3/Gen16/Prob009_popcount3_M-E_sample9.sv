module TopModule(
    input [2:0] in,
    output [1:0] out
);

    // First level: Compare each pair of bits
    wire bit0_and_bit1;
    wire bit0_xor_bit1;
    wire bit2;

    assign bit0_and_bit1 = in[0] & in[1];
    assign bit0_xor_bit1 = in[0] ^ in[1];
    assign bit2 = in[2];

    // Second level: Combine results to get the final count
    wire count_bit0_bit1;
    wire final_count;

    assign count_bit0_bit1 = (bit0_and_bit1)? 2'b10 : (bit0_xor_bit1)? 2'b01 : 2'b00;
    assign final_count = count_bit0_bit1 + {1'b0, bit2};

    // Assign the final result to the output
    assign out = final_count[1:0];

endmodule
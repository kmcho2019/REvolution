module TopModule(
    input [2:0] in,
    output [1:0] out
);

    wire [1:0] msb_count;
    wire [1:0] lsb_count;

    // Count the '1's in the most significant bit
    assign msb_count = (in[2] == 1) ? 2'b01 : 2'b00;

    // Count the '1's in the least significant two bits
    assign lsb_count = in[0] + in[1];

    // Combine the partial counts to produce the final output
    assign out = msb_count + lsb_count;

endmodule
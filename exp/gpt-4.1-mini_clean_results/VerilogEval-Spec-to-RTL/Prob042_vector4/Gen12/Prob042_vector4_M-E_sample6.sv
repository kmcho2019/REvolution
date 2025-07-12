module TopModule (
    input  [7:0] in,
    output reg [31:0] out
);
    integer i;
    reg sign_bit_replicated [23:0];

    always @(*) begin
        // Replicate the sign bit 24 times in an array
        for (i = 0; i < 24; i = i + 1) begin
            sign_bit_replicated[i] = in[7];
        end
        // Concatenate replicated sign bits and original input
        out = { {sign_bit_replicated[23], sign_bit_replicated[22], sign_bit_replicated[21],
                 sign_bit_replicated[20], sign_bit_replicated[19], sign_bit_replicated[18],
                 sign_bit_replicated[17], sign_bit_replicated[16], sign_bit_replicated[15],
                 sign_bit_replicated[14], sign_bit_replicated[13], sign_bit_replicated[12],
                 sign_bit_replicated[11], sign_bit_replicated[10], sign_bit_replicated[9],
                 sign_bit_replicated[8],  sign_bit_replicated[7],  sign_bit_replicated[6],
                 sign_bit_replicated[5],  sign_bit_replicated[4],  sign_bit_replicated[3],
                 sign_bit_replicated[2],  sign_bit_replicated[1],  sign_bit_replicated[0] },
                in };
    end
endmodule